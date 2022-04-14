from std/json import JsonNode

type
  CurveType* {.pure.} = enum
    tri,   ## riangular, linear slope (default)  afade - triangular curve
    qsin,  ## quarter of sine wave  afade - quarter sine wave curve
    hsin,  ## half of sine wave  afade -  half sine wave curve
    esin,  ## exponential sine wave  afade -  exponential sine wave curve
    log,   ## logarithmic  afade -  logarithmic curve
    ipar,  ## inverted parabola  afade -  inverted parabola curve
    qua,   ## quadratic  afade - quadratic curve
    cub,   ## cubic  afade - cubic curve
    squ,   ## square root  afade - square root curve
    cbr,   ## cubic root  afade - cubic root curve
    par,   ## parabola  afade - parabola curve
    exp,   ## exponential  afade -  exponential curve
    iqsin, ## inverted quarter of sine wave  afade -  inverted quarter sine wave curve
    ihsin, ## inverted half of sine wave  afade -  inverted half sine wave curve
    dese,  ## double-exponential seat  afade - double-exponential seat curve
    desi,  ## double-exponential sigmoid  afade - double-exponential sigmoid curve
    losi,  ## logistic sigmoid  afade -  logistic sigmoid curve
    nofade ## no fade
  TransitionType* {.pure.} = enum
    directionalLeft = "directional-left",
    directionalRight = "directional-right",
    directionalUp = "directional-up",
    directionalDown = "directional-down",
    random,
    dummy
  LayerKind* {.pure.} = enum
    none,
    video = "video",
    audio = "audio",
    detachedAudio = "detached-audio",
    image = "image",
    imageOverlay = "image-overlay",
    title = "title",
    subtitle = "subtitle",
    titleBackground = "title-background",
    newsTitle = "news-title",
    slideInText = "slide-in-text",
    fillColor = "fill-color",
    pause = "pause",
    radialGradient = "radial-gradient",
    linearGradient = "linear-gradient",
    rainbowColors = "rainbow-colors",
    # canvas = "canvas", # Needs JS
    # fabric = "fabric", # Needs JS
    gl = "gl",
    editlyBanner = "editly-banner"
  OriginX* {.pure.} = enum
    left = "left",
    center = "center",
    right = "right"
  OriginY* {.pure.} = enum
    top = "top",
    center = "center",
    bottom = "bottom"
  Position* = enum
    none,
    top = "top",
    topLeft = "top-left",
    topRight = "top-right",
    center = "center",
    centerLeft = "center-left",
    centerRight = "center-right",
    bottom = "bottom",
    bottomLeft = "bottom-left",
    bottomRight = "bottom-right"
  ResizeMode* {.pure.} = enum
    contain = "contain",
    containBlur = "contain-blur",
    cover = "cover",
    stretch = "stretch"
  BackgroundLayerKind* {.pure.} = enum
    radialGradient, linearGradient, fillColor

type
  Layer* = object
    kind*: LayerKind
    backgroundColor*: string
    charSpacing*: int
    color*: string
    colors*: array[2, string]
    cutFrom*: int
    cutTo*: int
    duration*: int
    fontPath*: string
    fontSize*: int
    height*: float
    left*: float
    mixVolume*: string
    path*: string
    start*: int
    text*: string
    textColor*: string
    top*: float
    width*: float
    zoomAmount*: float
    zoomDirection*: string
    background*: BackgroundLayer
    originY*: OriginY
    originX*: OriginX
    position*: JsonNode
    resizeMode*: ResizeMode
    fragmentPath*: string
    vertexPath*: string
    speed*: float
  BackgroundLayer* = object
    case `type`: BackgroundLayerKind
    of BackgroundLayerKind.radialGradient,
      BackgroundLayerKind.linearGradient:
        colors*: array[2, string]
    of BackgroundLayerKind.fillColor:
      color*: string
