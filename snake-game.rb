R="\e[31m\u25C6\e[0m\e[32m ";U="\n\r";B="\u25FC ";Y="\u25CB ";$t=ARGV.first
.to_i.yield_self{|s|(s>12)?s:12};$r=0...$t+2;$i=[];$c=[];$k=[0,1];$x=->{$l=
[rand(1..$t),rand(1..$t)]while$l.nil?||$i[$l[0]][$l[1]]==B;$i[$l.first][$l[
1]]=R};require'io/console';$p=0;$s=0;$r.each{|x|$i.push$r.each_with_object(
[]){|y,r|r.push(x.between?(1,$t)&&y.between?(1,$t)?(Y):(B))}};Thread.new{$x
.();3.times{|i|$i[$t][1+i]=B;$c[i]=[$t,1+i]};loop{r=$c[$c.count-1][0];c=$c[
$c.size-1][1];(exit)if$i[r+$k[0]][c+$k[1]]==B;$i[r+$k.first][c+$k[1]]=B;$c.
push([r+$k[0],c+$k[1]]);(r==$l[0]&&c==$l[1])?($x.();$p+=(100-$s*10).itself.
yield_self{|a|a<1?1:(a)}+$u;$s=0):($i[$c[0][0]][$c[0][1]]=Y;$c.shift;$s+=1)
$u=($c.size-3)/10.0;system'clear';puts"\e[32m";$i.map(&lambda{|r|r.map(&$s.
method(:print));print(U)});print"\e[0mPoints:#{$p.to_i}#{U.to_s}Level:#{$u.
floor}#{U}Gems:#{($u*10).round(0)}";print(U);sleep(0.3-$u.floor.to_f/50.0)}
};loop{$stdin.getch;k=$stdin.read_nonblock(2)rescue(nil);$k=(k=='[A')?([-1,
0]):((k=='[B')?([1,0]):((k=='[C')?([0,1]):((k.eql?'[D')?([0,-1]):(exit))))}