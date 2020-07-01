import ../fancygl, fftw3

######################################################################
## WARNING: this code is just for me to play around with the fftw   ##
## library.  It has no intended educational value and has not been  ##
## updated for a long time, and doesn't even utilize this library   ##
## properly.  Honestly there is no reason this is even part of this ##
## codebase.  Just continue somewhere else, there is nothing to see ##
## here.                                                            ##
######################################################################

discard init(INIT_EVERYTHING)

var wav_spec: AudioSpec
var wav_length: uint32
var wav_buffer: ptr uint8

let resourcePath = getResourcePath("song.wav")
if loadWAV(resourcePath, wav_spec.addr, wav_buffer.addr, wav_length.addr) == nil:
  stderr.writeLine getError()
  stderr.writeLine "That file isn't provided in the repo just put any wav file there"
  quit(QUIT_FAILURE)

echo $wav_spec

var puffer = dataView[int16](wav_buffer.pointer, int(wav_length div 2))

var
  streamA = newSeq[float64](puffer.len)
  streamB = newSeq[float64](puffer.len)

for i in 0 ..< (puffer.len div 2):
  let
    x = puffer[i*2].float64
    y = puffer[i*2+1].float64
    z : float64 = pow(2.0,15) - 1

  streamA[i] = x / z
  streamB[i] = y / z
  # echo " "*int(30+streamA[i]*60), "x"

const N = 44100 div 60
var input : array[N, float64]
var output : array[2*N, float64]

let plan = fftw_plan_dft_r2c_1d(N, input[0].addr,
  cast[ptr fftw_complex](output[0].addr), FFTW_ESTIMATE)

const WIDTH = 640
const HEIGHT = 480

var
  window = createWindow("title", 0, 0, WIDTH, HEIGHT, 0)
  renderer = createRenderer(window, -1, RENDERER_PRESENTVSYNC)

  runGame: bool = true


for offset in 0 .. (wav_length div N):
  if not runGame:
    break

  for event in events():
    if event.kind == QUIT:
      runGame = false
      break
    if event.kind == KEY_DOWN and event.key.keysym.scancode == SCANCODE_ESCAPE:
      runGame = false

  # update data code

  for i in 0 ..< N:
    input[i] = streamA[int(offset)*N + i]
  fftw_execute(plan)

  # rendering code

  discard renderClear(renderer)

  for i in 0 ..< N:
      let x = output[i] * WIDTH / 12 + WIDTH / 2
      let y = output[i+1] * HEIGHT / 12 + HEIGHT / 2
      discard renderDrawPoint(renderer, cint(x), cint(y))

  renderPresent(renderer)
