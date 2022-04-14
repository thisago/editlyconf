from std/json import JsonNode
from std/tables import Table

# FFmpeg
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

type
  TransitionType* {.pure.} = enum
    directionalLeft = "directional-left",
    directionalRight = "directional-right",
    directionalUp = "directional-up",
    directionalDown = "directional-down",
    random,
    dummy
  LayerType* {.pure.} = enum
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
    canvas = "canvas",
    fabric = "fabric",
    gl = "gl",
    editlyBanner = "editly-banner"
  ResizeMode* {.pure.} = enum 
    contain = "contain",
    containBlur = "contain-blur",
    cover = "cover",
    stretch = "stretch"
  OriginX* {.pure.} = enum
    left = "left",
    center = "center",
    right = "right"
  OriginY* {.pure.} = enum
    top = "top",
    center = "center",
    bottom = "bottom"
  Position* = JsonNode
  BackgroundLayerKind* {.pure.} = enum
    radialGradient, linearGradient, fillColor
  # Position* {.pure.} = enum
  #   top = "top",
  #   topLeft = "top-left",
  #   topRight = "top-right",
  #   center = "center",
  #   centerLeft = "center-left",
  #   centerRight = "center-right",
  #   bottom = "bottom",
  #   bottomLeft = "bottom-left",
  #   bottomRight = "bottom-right",
  #   PositionObject
type
  EditlyConfig* = ref object
    outPath*: string
    clips*: seq[EditlyClip]
    width*, height*: int
    fps*: int
    customOutputArgs*: seq[string]
    allowRemoteRequests*: bool
    fast*: bool
    defaults*: EditlyConfigDefaults
  EditlyClip* = ref object
    layers*: seq[EditlyConfigLayer]
    duration*: int
    transition*: EditlyConfigTransition
  EditlyConfigLayer* = ref object
    start*: int
    stop*: int
    case `type`: LayerType
    of video:
      path*: string
      resizeMode*: ResizeMode
      cutFrom*, cutTo*: int
      width*, height*: float
      left*, top*: float
      originX*: OriginX
      originY*: OriginY
      mixVolume*: string
    of audio:
      path*: string
      cutFrom*, cutTo*: int
      mixVolume*: string
    of detachedAudio:
      path*: string
      cutFrom*, cutTo*: int
      mixVolume*: string
      start*: int
    of image:
      path*: string
      resizeMode*: ResizeMode
      duration*: int
      zoomDirection*: string ## 'in' | 'out' | null
      zoomAmount*: float
    of imageOverlay:
      path*: string
      position*: Position
      resizeMode*: ResizeMode
      width*, height*: float
      zoomDirection*: string ## 'in' | 'out' | null
      zoomAmount*: float
    of imageOverlay:
      path*: string
      text*: string
      textColor*: string
      fontPath*: string
      position*: Position
      zoomDirection*: string ## 'in' | 'out' | null
      zoomAmount*: float
    of subtitle:
      text*: string
      textColor*: string
      fontPath*: string
      backgroundColor*: string
    of titleBackground:
      text*: string
      textColor*: string
      fontPath*: string
      background*: BackgroundLayer
    of newsTitle:
      text*: string
      textColor*: string
      fontPath*: string
      backgroundColor*: string
      position*: Position
    of slideInText:
      text*: string
      textColor*: string
      fontPath*: string
      fontSize*: int
      charSpacing*: int
      color*: string
      position*: Position
    else: discard
    
  BackgroundLayer* = ref object
    case `type`: BackgroundLayerKind
    of BackgroundLayerKind.radialGradient,
      BackgroundLayerKind.linearGradient:
        colors*: array[2, string]
    of BackgroundLayerKind.fillColor:
      color*: string

  EditlyConfigTransition* = ref object
    duration*: int
    name*: TransitionType
    audioOutCurve*: CurveType
    audioInCurve*: CurveType
    easing: string
    params: EditlyConfigTransitionParams
  EditlyConfigTransitionParams* = Table[string, JsonNode] ## JsonNode = number or boolean or object or seq[number]
  EditlyConfigDefaults* = ref object
    duration: float
    layers*: EditlyConfigDefaultLayers
    layerType*: EditlyConfigDefaultLayerType
    transition*: EditlyConfigDefaultTransition
  EditlyConfigDefaultLayers* = Table[string, string]
  EditlyConfigDefaultLayerType* = Table[LayerType, Table[string, string]] ## https://github.com/mifi/editly#layer-types
  EditlyConfigDefaultTransition* = EditlyConfigTransition


  #   defaults*: EditlyConfigDefaults
  # EditlyConfigDefaults* = ref object
  #   duration: int
  #   transition: EditlyConfigTransition
  # EditlyConfigTransition* = ref object
  #   duration: float
  #   name: TransitionTypes
  #   audioOutCurve: FadeCurve
  #   audioInCurve: FadeCurve
  #   layer: EditlyConfigTransitionLayer
  #   layerType: EditlyConfigTransitionLayerType
  # EditlyConfigTransitionLayer* = ref object
  #   fontPath: string
  #   # ...more layer defaults
  # EditlyConfigTransitionLayerType* = ref object
  #   'fill-color': {
  #     color: '#ff6666',
  #   }
  #   # ...more per-layer-type defaults
