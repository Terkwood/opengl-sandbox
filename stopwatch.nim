
#proc getPerformanceCounter(): uint64
#proc getPerformanceFrequency(): uint64

type
  StopWatch* = object
    ## a stopwatch that uses the performance counter from sdl internally
    value : int64  # when running it's the offset, otherwise, it's the timer when it was stopped the last time
    running: bool

proc reset*(this: var StopWatch): void =
  ## sets the timer to zero
  this.value = getPerformanceCounter().int64

proc newStopWatch*(running: bool; startTime: float64 = 0.0) : StopWatch =
  ## creates a new stop watch
  result.value   = getPerformanceCounter().int64 - int64(startTime * getPerformanceFrequency().float64)
  result.running = running
  
proc toggle*(this: var StopWatch): void =
  ## toggles the stop watch 
  this.running = not this.running
  this.value = getPerformanceCounter().int64 - this.value

proc cont*(this: var StopWatch): void =
  ## continues the stopwatch when stopped
  if not this.running:
    this.toggle

proc stop*(this: var StopWatch): void =
  ## stops the stopwatch when running
  if this.running:
    this.toggle

proc time*(this: StopWatch): float64 =
  ## returns time in seconds
  let counter = 
    if this.running:
      getPerformanceCounter().int64 - this.value
    else:
      this.value

  float64(counter) / float64(getPerformanceFrequency())

proc running*(this: StopWatch): bool =
  ## tells weather this stopwatch is running
  this.running
  
