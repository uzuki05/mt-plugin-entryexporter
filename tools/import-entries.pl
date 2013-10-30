#!/usr/bin/env perl

# EntryExporter Plug-in
# perl tools/import-entries --blog_id=2 --user_id=1 path-th-archive/entries-YYYYMMDDHHMMSS.zip

use strict;
use utf8;

use strict;
use warnings;

use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';

use Data::Dumper;

use MT;
use MT::Util;

package MT;
sub mode {
    'import-entries';
}
sub user {
    my $app = shift;
    $app->{ author } = $_[0] if @_;
    return $app->{ author };
}

package main;

use Getopt::Long;
use Pod::Usage;
GetOptions(
    "config=s" => \my ( $cfg ),
    "blog_id=s" => \my ( $blog_id ),
    "user_id=s" => \my ( $user_id ) );

$cfg = 'mt-config.cgi' unless  defined $cfg;

my $app = new MT(($cfg ? ('Config' => $cfg) : ())) or die MT->errstr;
$app->{vtbl}                 = {};
$app->{is_admin}             = 0;
$app->{template_dir}         = 'cms';
$app->{user_class}           = 'MT::Author';
$app->{plugin_template_path} = 'tmpl';
$app->run_callbacks( 'init_app', $app );

my $blog = $blog_id ? MT->model( 'blog' )->load( $blog_id ) : undef;
$blog or pod2usage("no given blog");
my $user = $user_id ? MT->model( 'author' )->load( $user_id ) : undef;
$user or pod2usage("no given user");
$app->user( $user );
my $archive_path = $ARGV[0] or pop2usage("no given archivepath");

require EntryExporter::Plugin;
EntryExporter::Plugin::import_entries( $blog, $archive_path );


1;
