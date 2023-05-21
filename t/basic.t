use strict;
use warnings;
use Test2::Bundle::More;

use JavaScript::WebAPIs;

my $path = JavaScript::WebAPIs::share_path('main.js');

ok(ref $path eq 'Path::Tiny', 'share_path return is Path::Tiny');
ok($path->exists, 'main.js in Path::Tiny object exists');

my $main_js = JavaScript::WebAPIs::main_js();
my $main_min_js = JavaScript::WebAPIs::main_min_js();

ok((defined $main_js and ref $main_js eq '') ? 1 : 0, 'main_js is defined and a string');
ok((defined $main_min_js and ref $main_min_js eq '') ? 1 : 0, 'main_min_js is defined and a string');
ok(length $main_js > 1_000_000, 'main_js size looks legit');
ok(length $main_min_js > 500_000, 'main_min_js size looks legit');
ok(length $main_js > length $main_min_js, 'main_js bigger than main_min_js');

done_testing;
