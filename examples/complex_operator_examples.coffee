Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.range(1,2)
  .flatMap (x) ->
    Rx.Observable.range(x * 10, 2)
      .delay(x * 500)
  .subscribe(createObserver())

# 10 (at 500 ms)
# 11 (at 500 ms)
# 20 (at 1000 ms)
# 21 (at 1000 ms)
# completed (at 1000 ms)

Rx.Observable.interval(500)
  .takeUntil(Rx.Observable.timer(2000))
  .subscribe(createObserver())

# 0 (at 500 ms)
# 1 (at 1000 ms)
# 2 (at 1500 ms)
# completed (at 2000 ms)

Rx.Observable.interval(500)
  .combineLatest(Rx.Observable.interval(700), (a, b) -> {a: a, b: b})
  .take(4)
  .subscribe(createObserver())

# { a: 0, b: 0 } (at 700 ms)
# { a: 1, b: 0 } (at 1000 ms)
# { a: 1, b: 1 } (at 1400 ms)
# { a: 2, b: 1 } (at 1500 ms)
# completed (at 1500 ms)

Rx.Observable.interval(300)
  .merge(Rx.Observable.interval(200))
  .take(6)
  .subscribe(createObserver())

# 0 (at 200 ms)
# 0 (at 300 ms)
# 1 (at 400 ms)
# 1 (at 600 ms)
# 2 (at 600 ms)
# 3 (at 800 ms)
# completed (at 800 ms)

Rx.Observable.interval(500)
  .zip(Rx.Observable.interval(200), (a, b) -> {a: a, b: b})
  .take(4)
  .subscribe(createObserver())

# { a: 0, b: 0 } (at 500 ms)
# { a: 1, b: 1 } (at 1000 ms)
# { a: 2, b: 2 } (at 1500 ms)
# { a: 3, b: 3 } (at 2000 ms)
# completed (at 2000 ms)
