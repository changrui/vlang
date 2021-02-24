// test performance of []thread and wait
// by Charles WANG, 2021
// changrui@live.com
module main 

import time

const (
   max = 1_000_000_000
   devide = 8        // by ncpu
)

fn main() {
   wait_3s()
   _ = sum_float()
   _ = classic_sum()
}

fn sum_float() f64 {
   println('\tCalculate `1+2+3+...+$max` ...')
   mut f := []thread f64{}
   d := max / devide

   sw := time.new_stopwatch({})
   for i in 0..devide {
      f << go sum(i*d, (i+1)*d)
   } 
   x := f.wait()
   
   mut e := 0.0
   for s in x {
      e += s
   }
   println('>>> Thread Sum  - Time used:  ${sw.elapsed().milliseconds()}ms, sum = ${e}.')
   return e
}

[inline]
fn sum(i f64, j f64) f64 {
   mut s := 0.0
   for k:=i; k<j+1; k = k + 1 {
      s += k
   } 
   return s
}

fn wait_3s() {
   sw := time.new_stopwatch({})
   r := [
      go second(1)
      go second(2)
      go second(3)
   ]   
   r.wait()
   //println('Type of thread: ${typeof(r).name}')
   println('>>> Thread - Total time used: ${sw.elapsed().milliseconds()}ms.')
}

fn second(i int) {
   println('Thread *$i* is running... only time.wait(1000ms)')
   time.wait(1000*time.millisecond)
}

fn classic_sum() f64 {
   mut s := f64(0)

   sw := time.new_stopwatch({})
   for k := 1.0; k <= max; k = k + 1 {
      s += k
   }
   println('>>> `1+2+..max` - Time used: ${sw.elapsed().milliseconds()}ms, Sum = ${s}.')
   return s
}
