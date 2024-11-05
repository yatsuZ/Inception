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
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

define( 'CONCATENATE_SCRIPTS', false ); 
define( 'SCRIPT_DEBUG', true );

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'nom_de_database_test' );

/** Database username */
define( 'DB_USER', 'root' );

/** Database password */
define( 'DB_PASSWORD', 'mdp_root' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

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
define( 'AUTH_KEY',         'f!~4a:gX^|BU1Z`w Etb@ta`U{Og/,=mw<$$>^S{yd5H1Q?4`lPt9{L9udoJqa0/' );
define( 'SECURE_AUTH_KEY',  'n1~anRTdD?~yf:!YIdz$QAX;XR25z)PxP9V@gU)verl*VK9lq.OLL!=$Vr.4TFo+' );
define( 'LOGGED_IN_KEY',    '+tl6dG18AB_J]_.]sAFIqtu^e4(cEK7m0-hGzH1!]M?9[@!b:?K;yp_$hM{iRs.f' );
define( 'NONCE_KEY',        'YOTEh^CUA;VOkOJmxqG%b+-d?/ppC;51&rz$1#>vS9fPO{QUp 4#PaqfL8g.,b*&' );
define( 'AUTH_SALT',        '7/<~do|62II0Kmg|gSf_4GE5DU~-In8uQ9kf!?(G5 wDHIqbZ:oB!9A_tpzQ~5nu' );
define( 'SECURE_AUTH_SALT', 'p=q+$3-80n*hGoj`zu=fR^)M$vB[f8PG>sAEj:nGfyDgZ-Uo9j<FmJBrpPz936[?' );
define( 'LOGGED_IN_SALT',   '1#Sp g)0*5;hh1BY7-6pRN+hddBsx3FNv{,ewv6P{H]oB3*KAl9z.&~qUqHpx5Tq' );
define( 'NONCE_SALT',       '5/7xRjuUXR(SS )w_.8=Q#Ah#PmC(hn q/$tKx^/n28Hnc6Zk#H{~f!SmL*8~<XY' );

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
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
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

