## This module converts JSON Editly configs into nim function calls

from std/json import parseJson, `{}`, getStr, JsonNode, JsonNodeKind, items,
                      getBool, getFloat, getInt, hasKey, keys, `$`
from std/strformat import fmt
from std/strutils import repeat, multiReplace, join

const
  comma = ","
  clsParen = ")" & comma
  clsCurly = "}" & comma
  clsBrkt = "]" & comma

func indent*(s: string, count: Natural, padding: string = "  "): string =
  strutils.indent(s, count, padding) & "\l"

func getProp(node: JsonNode; name: string): string =
  let n = node{name}
  if n.isNil: return
  result =
    case n.kind:
    of JBool:   $n.getBool
    of JFloat:  $n.getFloat
    of JInt:    $n.getInt
    of JString: "\"" & n.getStr & "\""
    of JObject: "[JSON Object]"
    of JArray:  "[JSON Array]"
    of JNull:   ""

func addProp[T](
  res: var T;
  node: JsonNode;
  prop: string;
  indentLevel = 1;
  escape = "";
  process = proc(s: string): string = s
) =
  var val = node.getProp prop
  if val.len > 0:
    val = process val
    var r = prop
    if escape.len > 0:
      r = escape
    r.add " = "
    r.add val
    r.add comma
    res.add r.indent indentLevel

func addTmp(
  res: var string;
  tmp: string
) =
  let
    test = tmp.multiReplace({
      "{": "",
      "}": "",
      "(": "",
      ")": "",
      "[": "",
      "]": "",
      "\l": "",
      " ": "",
      comma: "",
    })
  if test.len > 0:
    res.add tmp

func fixLayerKind(s: string): string =
  result = s[1..^2]
  result = 
    case result:
    of "detached-audio": "detachedAudio"
    of "image-overlay": "imageOverlay"
    of "title-background": "titleBackground"
    of "news-title": "newsTitle"
    of "in-text": "inText"
    of "fill-color": "fillColor"
    of "radial-gradient": "radialGradient"
    of "linear-gradient": "linearGradient"
    of "rainbow-colors": "rainbowColors"
    else: result

func removeQuotes(s: string): string =
  result = s[1..^2]

func addTransition(props: var string; node: JsonNode; indentLevel: int) =
  block transition:
    if node.hasKey "transition":
      let tr = node{"transition"}
      var l = ""
      l.add "transition = newEditlyTransition(".indent indentLevel
      let insideIndent = indentLevel + 1
      l.addProp(tr, "duration", indentLevel = insideIndent)
      l.addProp(tr, "name", indentLevel = insideIndent, process = removeQuotes)
      l.addProp(tr, "audioInCurve", indentLevel = insideIndent, process = removeQuotes)
      l.addProp(tr, "audioOutCurve", indentLevel = insideIndent, process = removeQuotes)
      l.addProp(tr, "easing", indentLevel = insideIndent)
      block params:
        if tr.hasKey "params":
          l.add "params = newEditlyTransitionParams(".indent insideIndent
          let trParams = tr{"params"}
          for key in trParams.keys:
            l.add fmt"""("{key}", %{$trParams.getProp key}),""".indent 5
          l.add clsParen.indent insideIndent
          
      l.add clsParen.indent indentLevel
      props.add l

proc translateEditlyConf(conf: string): string =
  let node = parseJson conf
  result = "newEditlyConfig(".indent 0
  
  result.addProp(node, "outPath", indentLevel = 1)

  block clips:
    result.add "clips = newEditlyClips(".indent 1
    var tmp = ""
    for clip in node{"clips"}:
      tmp.add "newEditlyClip(".indent 2
      var clipProps: string
      block layers:
        var l = ""
        l.add "layers = newEditlyLayers(".indent 3
        for layer in clip{"layers"}:
          l.add "newEditlyLayer(".indent 4
          l.addProp(layer, "type", indentLevel = 5, escape = "kind", fixLayerKind)
          l.addProp(layer, "backgroundColor", indentLevel = 5)
          l.addProp(layer, "charSpacing", indentLevel = 5)
          l.addProp(layer, "color", indentLevel = 5)
          l.addProp(layer, "colors", indentLevel = 5)
          l.addProp(layer, "cutFrom", indentLevel = 5)
          l.addProp(layer, "cutTo", indentLevel = 5)
          l.addProp(layer, "duration", indentLevel = 5)
          l.addProp(layer, "fontPath", indentLevel = 5)
          l.addProp(layer, "fontSize", indentLevel = 5)
          l.addProp(layer, "height", indentLevel = 5)
          l.addProp(layer, "left", indentLevel = 5)
          l.addProp(layer, "mixVolume", indentLevel = 5)
          l.addProp(layer, "path", indentLevel = 5)
          l.addProp(layer, "start", indentLevel = 5)
          l.addProp(layer, "text", indentLevel = 5)
          l.addProp(layer, "textColor", indentLevel = 5)
          l.addProp(layer, "top", indentLevel = 5)
          l.addProp(layer, "width", indentLevel = 5)
          l.addProp(layer, "zoomAmount", indentLevel = 5)
          l.addProp(layer, "zoomDirection", indentLevel = 5)
          l.addProp(layer, "background", indentLevel = 5)
          l.addProp(layer, "originY", indentLevel = 5)
          l.addProp(layer, "originX", indentLevel = 5)
          l.addProp(layer, "position", indentLevel = 5)
          l.addProp(layer, "resizeMode", indentLevel = 5)
          l.addProp(layer, "fragmentPath", indentLevel = 5)
          l.addProp(layer, "vertexPath", indentLevel = 5)
          l.addProp(layer, "speed", indentLevel = 5)
          l.add clsParen.indent 4
        l.add clsParen.indent 3
        
        clipProps.add l
      clipProps.addTransition(clip, indentLevel = 3)
          
      clipProps.addProp(clip, "duration", indentLevel = 3)
      tmp.add clipProps
      tmp.add clsParen.indent 2
      if clipProps.len > 0:
        result.addTmp tmp
      tmp = ""
    result.add clsParen.indent 1

  result.addProp(node, "width", indentLevel = 1)
  result.addProp(node, "height", indentLevel = 1)
  result.addProp(node, "fps", indentLevel = 1)

  block customOutputArgs:
    if node.hasKey "customOutputArgs":
      result.add "customOutputArgs = @[".indent 1
      var list: seq[string]
      for arg in node{"customOutputArgs"}:
        list.add "\"" & arg.getStr & "\""
      result.add list.join(",\l").indent 2
      result.add clsBrkt.indent 1

  result.addProp(node, "allowRemoteRequests", indentLevel = 1)
  result.addProp(node, "fast", indentLevel = 1)

  block defaults:
    if node.hasKey "defaults":
      let def = node{"defaults"}
      result.add "defaults = newEditlyDefaults(".indent 1
      result.addProp(def, "duration", indentLevel = 2)
      block layer:
        if def.hasKey "layer":
          result.add "layer = newEditlyLayer(".indent 2
          let lay = def{"layer"}
          for key in lay.keys:
            result.addProp(lay, key, indentLevel = 3)
          result.add clsParen.indent 2
      block layerType: ## TODO: A generation func to this object
        if def.hasKey "layerType":
          result.add "layerType = %*{".indent 2
          let layTy = def{"layerType"}
          for key in layTy.keys:
            let val = layTy.getProp key
            result.add fmt""""{key}": {val},""".indent 3
          result.add clsCurly.indent 2
        result.addTransition def, 2

      result.add clsParen.indent 1
      


  result.add ")".indent 0

when isMainModule:
  let path = "tests/translate/"
  writeFile path & "out.nim", translateEditlyConf readFile path & "in.json"
