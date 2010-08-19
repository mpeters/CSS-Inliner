use Test::More;
plan(tests => 8);

use_ok('CSS::Inliner');

my $html = <<END;
<html>
 <head>
  <title>Test Document</title>
  <style type="text/css">
   .foo { color: red }
   .bar { color: blue; font-weight: bold; }
   .biz { color: green; font-size: 10px; }
  </style>
  <body>
    <h1 class="foo bar biz">Howdy!</h1>
    <h1 class="foo biz bar">Ahoy!</h1>
    <h1 class="bar biz foo">Hello!</h1>
    <h1 class="bar foo biz">Hola!</h1>
    <h1 class="biz foo bar">Gudentag!</h1>
    <h1 class="biz bar foo">Dziendobre!</h1>
  </body>
</html>
END

my $inliner = CSS::Inliner->new();
$inliner->read({html => $html});
$inliner->_get_css();

#shuffle stored styles around
my $shuffle1 = 0;
foreach (keys %{$css}) { $shuffle1++;}

#shuffle stored styles around more
my $shuffle2 = 0;
while ( each %{$css} ) {$shuffle2++;}

my $inlined = $inliner->inlinify();

ok($shuffle1 == $shuffle2);
ok($inlined =~ m/<h1 class="foo bar biz" style="color: green; font-size: 10px; font-weight: bold;">Howdy!<\/h1>/, 'order #1');
ok($inlined =~ m/<h1 class="foo biz bar" style="color: green; font-size: 10px; font-weight: bold;">Ahoy!<\/h1>/, 'order #2');
ok($inlined =~ m/<h1 class="bar biz foo" style="color: green; font-size: 10px; font-weight: bold;">Hello!<\/h1>/, 'order #3');
ok($inlined =~ m/<h1 class="bar foo biz" style="color: green; font-size: 10px; font-weight: bold;">Hola!<\/h1>/, 'order #4');
ok($inlined =~ m/<h1 class="biz foo bar" style="color: green; font-size: 10px; font-weight: bold;">Gudentag!<\/h1>/, 'order #5');
ok($inlined =~ m/<h1 class="biz bar foo" style="color: green; font-size: 10px; font-weight: bold;">Dziendobre!<\/h1>/, 'order #6');
