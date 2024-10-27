<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'username_here' );

/** Database password */
define( 'DB_PASSWORD', 'password_here' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

$redis_server = array(
	'host'     => 'redis',
	'port'     => 6379,
	'auth'     => 'REDIS_PASSWORD',
	'database' => 0, // Optionally use a specific numeric Redis database. Default is 0.
);

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '*~:~P3dY>B6+{7;F?,E!=+42g!p>kY%6`E.o/wjT{sGN-$;IbQFUwYy65WFQji><');
define('SECURE_AUTH_KEY',  '}n+{HhL7tunOK5|bg1Fvh^vJD9nd><lXDR}>5}q(m-<30S@pn}TeqUr>E=4(lc@N');
define('LOGGED_IN_KEY',    'cWa,g2|&o:z<n!z/bUOk:l^5</3gdP<c0G00i=WJs6=:Bh,J]+r&N?+;n9H/nE>!');
define('NONCE_KEY',        'fnjF_]x^Y`r7qgkuiYn;z#=_Pq],0 dhGl{V5)6[W&2zk-wkR)>3`aq*<X[8my0J');
define('AUTH_SALT',        '#zJ#X|sq/7Xtuw*<,dC--f&E={8!BQ]u<){u<>e;Q=Fn*| =4I1zX[-;-RTGuAr*');
define('SECURE_AUTH_SALT', 'c9mZMtcKuD8^n:B}>peEVQcto3_qY[=|2mXnO)B+Flu&(K6/ Gd`R=4^hkPSYOX/');
define('LOGGED_IN_SALT',   'R5$*gxB6G{W-t0*Q _D8r9jxx@u;G_[lgZNQf1Cc_$uurbz6M8yO92w$lm%jZqd1');
define('NONCE_SALT',       '~_)V4$4/fn(>An5|_-8-C+w|y!evGit4I:nmnsrC&CW56l;<FYHK mU4_dzHrTE>');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
