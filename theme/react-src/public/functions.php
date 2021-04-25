<?php

/**
 * Enables the use of post thumbnails
 */
function support_post_thumbnails()
{
  add_theme_support('post-thumbnails');
}
add_action('after_setup_theme', 'support_post_thumbnails');

/**
 * Custom excerpt trim function
 * 
 * @remarks
 * This function removes the script tags if there are any, and retains
 * the paragraph structure of the post or page
 * It is meant as a replacement of the default wp_trim_excerpt function
 */
function wp_trim_excerpt_custom($text = '', $post = null)
{
  $raw_excerpt = $text;
  if ('' == $text) {
    $post = get_post($post);
    $text = get_the_content('', false, $post);
    $text = preg_replace('@<script[^>]*?>.*?</script>@si', '', $text);
    $excerpt_length = 50;
    $words = explode(' ', $text, $excerpt_length + 1);
    if (count($words) > $excerpt_length) {
      array_pop($words);
      $text = implode(' ', $words);
      $text .= "...";
    }
  }
  return apply_filters('wp_trim_excerpt', $text, $raw_excerpt);
}
remove_filter('get_the_excerpt', 'wp_trim_excerpt');
add_filter('get_the_excerpt', 'wp_trim_excerpt_custom');

/**
 * Handles query on both pages and posts
 * 
 * WordPress supplied json endpoints only support page or post querying.
 * However this may not be enough in a case where the url paths do not
 * indicate the type of singular we want to fetch.
 * 
 * @remarks
 * Currently this function only handles post/page queries through slugs
 * however this behavior can be easily modified if need be.
 * 
 * @param request request object from register_rest_route
 * @errors 
 * if the query finds no post/page with the given slug, it 
 *  returns `singular_no_match`
 * if the query finds more than one post/page with the given slug, 
 *  it returns `singular_multiple_match` 
 */
function get_singular($request)
{
  $args = array(
    'post_type' => array('post', 'page'),
    'name' => $request['slug'],
  );

  try {
    $the_query = new WP_Query($args);
    $body;
    
    switch ($the_query->post_count) {
      case 0:
        throw new ErrorException('singular_no_match');
        break;
      case 1:
        $the_query->the_post();
        global $post;
        $body = build_post_item();
        break;
      default:
        throw new ErrorException('singular_multiple_match');
    }
  
    return build_success_response($body);
  } catch (Exception $e) {
    return build_error_response($e->getMessage(), $args);
  }
}

/**
 * Returns all the posts in a given category
 * 
 * @remarks
 * wp-json posts endpoint supports returning posts for a certain category 
 * but it only allows this if we are querying a category id. It doesn't support
 * querying a category_name (slug). This method allows that
 * 
 * @param request request object from `register_rest_route`
 * @errors
 * Returns the WP_query errors if any happens
 */
function get_category_posts($request)
{
  $args = array(
    'category_name' => $request['slug'],
  );

  try {
    $the_query = new WP_Query($args);
    $body = array();

    if ($the_query->have_posts()) {
      while ($the_query->have_posts()) {
        $the_query->the_post();
        $item = build_post_item();
        array_push($body, $item);
      }
    }
  
    return build_success_response($body);

  } catch( Exception $e) {
    return build_error_response('category_posts_fetch_fail', $args);
  }
}

/**
 * Builds a standardized success response for any wrt endpoint
 */
function build_success_response($body) {
  return array(
    'state' => 'success',
    'body' => $body,
  );
}

/**
 * Builds a standardized error response for any wrt endpoint
 */
function build_error_response($error_code, $args)
{
  return array(
    'state' => 'fail',
    'errorCode' => $error_code,
    'meta' => $args,
  );
}

/**
 * Builds a post item for endpoints to consume
 * 
 * @remarks
 * Regular wp post object contains some properties that most renders do not 
 * require while omitting some that are commonly needed. This function 
 * tries to create a more ideal post item object for the client to consume. 
 */
function build_post_item()
{
  global $post;
  $categories = get_the_category($post->ID);

  $item = array(
    'title' => $post->post_title,
    'id' => $post->ID,
    'content' => apply_filters('the_content', $post->post_content),
    'type' => $post->post_type,
    'author' => $post->post_author,
    'date' => $post->post_date,
    'excerpt' => $post->post_excerpt,
    'status' => $post->post_status,
    'slug' => $post->post_name,
    'category' => $categories[0]->cat_name,
    'comment_count' => $post->comment_count,
    'comment_status' => $post->comment_status,
    'thumbnail' => get_the_post_thumbnail(),
  );
  wp_reset_postdata();
  return $item;
}

add_action('rest_api_init', function () {

  /**
   * Registers an endpoint for querying singulars (posts and pages) 
   * at the same time
   */
  register_rest_route('wrt/v1', 'singular', array(
    'methods' => 'GET',
    'callback' => 'get_singular',
    'args' => array(
      'slug' => array(
        'validate_callback' => function($param) {return true;}
      )
    )
  ));

  /**
   * Registers an endpoint that allows querying posts of the same 
   * category by the category slug (category_name)
   */
  register_rest_route('wrt/v1', '/category_posts', array(
    'methods' => 'GET',
    'callback' => 'get_category_posts',
    'args' => array(
      'slug' => array(
        'validate_callback' => function($param) {return true;}
      )
    )
  ));
});