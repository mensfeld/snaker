R="\e[31m\u25C6\e[0m\e[32m "
U="\n\r"
B="\u25FC "
Y="\u25CB "

$t=ARGV[0].to_i.yield_self{|s|(s>12)?s:12}
$r=0...$t+2
$i=[]
$c=[]
$k=[0,1]

$x=->{
  $l=[rand(1..$t),rand(1..$t)]while$l.nil?||$i[$l[0]][$l[1]]==B
  $i[$l[0]][$l[1]]=R
}

require'io/console';
$p=0
$s=0

$r.each{|x|$i.push$r.each_with_object([]){|y,r|r.push(x.between?(1,$t)&&y.between?(1,$t)?(Y):(B))}}

Thread.new{
  $x.()

  3.times{|i|
    $i[$t][1+i]=B
    $c[i]=[$t,1+i]
  }

  loop{
    r=$c[$c.size-1][0]
    c=$c[$c.size-1][1]

    exit if$i[r+$k[0]][c+$k[1]]==B

    $i[r+$k[0]][c+$k[1]]=B
    $c.push([r+$k[0],c+$k[1]])

    if r==$l[0]&&c==$l[1]
      $x.()
      $p+=(100-$s*10).yield_self{|a|a<1?1:(a)}+$u
      $s=0
    else
      $i[$c[0][0]][$c[0][1]]=Y
      $c.shift
      $s+=1
    end
    $u=($c.size-3)/10.0

    system'clear'
    print"\e[32m"

    l=->(r){
      r.each(&method(:print))
      print(U)
    }
    $i.each(&l)
    print"\e[0mPoints:#{$p.to_i}#{U}Level:#{($u).floor}#{U}Gems:#{($u*10).to_i}"
    print(U)
    sleep(0.30-($u/10.0).floor)
  }
}

loop{
  $stdin.getch
  case($stdin.read_nonblock(2)rescue(nil))
  when'[A'
    $k=[-1,0]
  when'[B'
    $k=[1,0]
  when'[C'
    $k=[0,1]
  when'[D'
    $k=[0,-1]
  else
    exit
  end
}
