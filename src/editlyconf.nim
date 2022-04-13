# FFmpeg
type
  FadeCurve* {.pure.} = enum
    tri,   ## riangular, linear slope (default)	afade - triangular curve
    qsin,  ## quarter of sine wave	afade - quarter sine wave curve
    hsin,  ## half of sine wave	afade -  half sine wave curve
    esin,  ## exponential sine wave	afade -  exponential sine wave curve
    log,   ## logarithmic	afade -  logarithmic curve
    ipar,  ## inverted parabola	afade -  inverted parabola curve
    qua,   ## quadratic	afade - quadratic curve
    cub,   ## cubic	afade - cubic curve
    squ,   ## square root	afade - square root curve
    cbr,   ## cubic root	afade - cubic root curve
    par,   ## parabola	afade - parabola curve
    exp,   ## exponential	afade -  exponential curve
    iqsin, ## inverted quarter of sine wave	afade -  inverted quarter sine wave curve
    ihsin, ## inverted half of sine wave	afade -  inverted half sine wave curve
    dese,  ## double-exponential seat	afade - double-exponential seat curve
    desi,  ## double-exponential sigmoid	afade - double-exponential sigmoid curve
    losi,  ## logistic sigmoid	afade -  logistic sigmoid curve
    nofade ## no fade

type
  TransitionTypes* {.pure.} = enum
    directionalLeft = "directional-left",
    directionalRight = "directional-right",
    directionalUp = "directional-up",
    directionalDown = "directional-down",
    random,
    dummy

type
  EditlyConfig* = ref object
    outPath*: string
    width*, height*: int
    fps*: int
    allowRemoteRequests*: bool
    defaults*: EditlyConfigDefaults
  EditlyConfigDefaults* = ref object
    duration: int
    transition: EditlyConfigTransition
  EditlyConfigTransition* = ref object
    duration: float
    name: TransitionTypes
    audioOutCurve: FadeCurve
    audioInCurve: FadeCurve
    layer: EditlyConfigTransitionLayer
    layerType: EditlyConfigTransitionLayerType
  EditlyConfigTransitionLayer* = ref object
    fontPath: string
    # ...more layer defaults
  EditlyConfigTransitionLayerType* = ref object
    'fill-color': {
      color: '#ff6666',
    }
    # ...more per-layer-type defaults
