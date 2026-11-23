# rinzu.macos API reference

Generated from checked public exports and captured source comments.

Language: `rinzu-0.5` · target: `aarch64-apple-darwin` · semantics: `rinzu-language-0.5-r85`.

Generate the machine-readable snapshot with `rinzu api . --output api.json`.

## rinzu.macos.AlertOptions

class · [source](../src/macos.rinzu#L1251).

```rinzu
class AlertOptions
```

Button roles are one-based. Use zero to omit a role.

### field title

[source](../src/macos.rinzu#L1252).

```rinzu
title: String
```

### field message

[source](../src/macos.rinzu#L1253).

```rinzu
message: String
```

### field buttons

[source](../src/macos.rinzu#L1254).

```rinzu
buttons: List<String>
```

### field style

[source](../src/macos.rinzu#L1255).

```rinzu
style: Int
```

### field defaultButton

[source](../src/macos.rinzu#L1256).

```rinzu
defaultButton: Int
```

### field cancelButton

[source](../src/macos.rinzu#L1257).

```rinzu
cancelButton: Int
```

## rinzu.macos.AlertOptions.create

Checked type: `fn(String,String,List<String>)->AlertOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1259).

```rinzu
fn create(title: String, message: String, buttons: List<String>) -> AlertOptions
```

## rinzu.macos.ApplicationOptions

class · [source](../src/macos.rinzu#L3130).

```rinzu
class ApplicationOptions
```

### field window

[source](../src/macos.rinzu#L3131).

```rinzu
const window: WindowOptions
```

### field activationPolicy

[source](../src/macos.rinzu#L3132).

```rinzu
activationPolicy: Int
```

### field signals

[source](../src/macos.rinzu#L3133).

```rinzu
signals: Bool
```

### field recoverEventOverflow

[source](../src/macos.rinzu#L3134).

```rinzu
recoverEventOverflow: Bool
```

## rinzu.macos.ApplicationOptions.create

Checked type: `fn(Float,Float)->ApplicationOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L3136).

```rinzu
fn create(width: Float, height: Float) -> ApplicationOptions
```

## rinzu.macos.Batch2D

class · [source](../src/macos.rinzu#L4117).

```rinzu
class Batch2D
```

Bounded, reusable quad batch. Coordinates and clip use target pixels, top-left.
Reset only after the command using its vertex buffer has physically settled.

### field vertices

[source](../src/macos.rinzu#L4118).

```rinzu
const vertices: Buffer
```

### field rgba

[source](../src/macos.rinzu#L4119).

```rinzu
const rgba: RenderPipeline
```

### field bgra

[source](../src/macos.rinzu#L4120).

```rinzu
const bgra: RenderPipeline
```

### field rgbaSrgb

[source](../src/macos.rinzu#L4121).

```rinzu
const rgbaSrgb: RenderPipeline
```

### field bgraSrgb

[source](../src/macos.rinzu#L4122).

```rinzu
const bgraSrgb: RenderPipeline
```

### field rgbaStraight

[source](../src/macos.rinzu#L4123).

```rinzu
const rgbaStraight: RenderPipeline
```

### field bgraStraight

[source](../src/macos.rinzu#L4124).

```rinzu
const bgraStraight: RenderPipeline
```

### field rgbaUnormStraight

[source](../src/macos.rinzu#L4125).

```rinzu
const rgbaUnormStraight: RenderPipeline
```

### field bgraUnormStraight

[source](../src/macos.rinzu#L4126).

```rinzu
const bgraUnormStraight: RenderPipeline
```

### field nearest

[source](../src/macos.rinzu#L4127).

```rinzu
const nearest: Sampler
```

### field linear

[source](../src/macos.rinzu#L4128).

```rinzu
const linear: Sampler
```

### field white

[source](../src/macos.rinzu#L4129).

```rinzu
const white: Texture
```

### field command

[source](../src/macos.rinzu#L4130).

```rinzu
const command: Command
```

### field capacity

[source](../src/macos.rinzu#L4131).

```rinzu
const capacity: Int
```

### field width

[source](../src/macos.rinzu#L4132).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L4133).

```rinzu
height: Int
```

### field count

[source](../src/macos.rinzu#L4134).

```rinzu
count: Int
```

### field draws

[source](../src/macos.rinzu#L4135).

```rinzu
draws: List<BatchDraw2D>
```

### field transform

[source](../src/macos.rinzu#L4136).

```rinzu
transform: Transform2D
```

### field clip

[source](../src/macos.rinzu#L4137).

```rinzu
clip: Scissor
```

### field filter

[source](../src/macos.rinzu#L4138).

```rinzu
filter: Int
```

### field closed

[source](../src/macos.rinzu#L4139).

```rinzu
closed: Bool
```

### field rendering

[source](../src/macos.rinzu#L4140).

```rinzu
rendering: Bool
```

## rinzu.macos.Batch2D.destroy

Checked type: `fn(Batch2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4433).

```rinzu
fn destroy(self: Batch2D)
```

## rinzu.macos.Batch2D.drawCallCount

Checked type: `fn(Batch2D)->Int`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L4283).

```rinzu
fn drawCallCount(self: Batch2D) -> Int
```

## rinzu.macos.Batch2D.encode

Checked type: `fn(Batch2D,Command,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4288).

```rinzu
fn encode(self: Batch2D, command: Command, format: Int) -> Int
```

Encode into an already begun pass. On Error the caller must abandon it.

## rinzu.macos.Batch2D.fillRect

Checked type: `fn(Batch2D,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4199).

```rinzu
fn fillRect(self: Batch2D, destination: Rect, color: Color)
```

## rinzu.macos.Batch2D.image

Checked type: `fn(Batch2D,Texture,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4217).

```rinzu
fn image(self: Batch2D, texture: Texture, destination: Rect, tint: Color)
```

## rinzu.macos.Batch2D.imageRegion

Checked type: `fn(Batch2D,Texture,Rect,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4223).

```rinzu
fn imageRegion(self: Batch2D, texture: Texture, destination: Rect, uv: Rect, tint: Color)
```

Normalized UVs with row zero at the top. Texture.alphaMode controls input alpha.
Tint is encoded sRGB on sRGB targets. Clear colors remain linear Metal colors.

## rinzu.macos.Batch2D.render

Checked type: `async(Batch2D,View,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4353).

```rinzu
async fn render(self: Batch2D, surface: View, clear: Color) -> Int
```

Own a complete frame, including abandon / physical drain on Error or cancel.

## rinzu.macos.Batch2D.renderTexture

Checked type: `async(Batch2D,Texture,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4387).

```rinzu
async fn renderTexture(self: Batch2D, texture: Texture, clear: Color) -> Int
```

Clear with a linear, straight-alpha color and produce a premultiplied texture.

## rinzu.macos.Batch2D.reset

Checked type: `fn(Batch2D,Int,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4142).

```rinzu
fn reset(self: Batch2D, width: Int, height: Int)
```

## rinzu.macos.Batch2D.setClip

Checked type: `fn(Batch2D,Scissor)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4170).

```rinzu
fn setClip(self: Batch2D, clip: Scissor)
```

## rinzu.macos.Batch2D.setFilter

Checked type: `fn(Batch2D,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4188).

```rinzu
fn setFilter(self: Batch2D, filter: Int)
```

## rinzu.macos.Batch2D.setTransform

Checked type: `fn(Batch2D,Transform2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4162).

```rinzu
fn setTransform(self: Batch2D, transform: Transform2D)
```

## rinzu.macos.Batch2D.text

Checked type: `fn(Batch2D,Text2D,Float,Float,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4204).

```rinzu
fn text(self: Batch2D, text: Text2D, x: Float, y: Float, tint: Color)
```

Coordinates use the current batch transform. TextMetrics uses font points.

## rinzu.macos.BatchDraw2D

class · [source](../src/macos.rinzu#L4105).

```rinzu
class BatchDraw2D
```

A contiguous draw span. Constructed by Batch2D; do not mutate batch storage.

### field texture

[source](../src/macos.rinzu#L4106).

```rinzu
const texture: Texture
```

### field textureId

[source](../src/macos.rinzu#L4107).

```rinzu
const textureId: Int
```

### field sampler

[source](../src/macos.rinzu#L4108).

```rinzu
const sampler: Sampler
```

### field filter

[source](../src/macos.rinzu#L4109).

```rinzu
const filter: Int
```

### field clip

[source](../src/macos.rinzu#L4110).

```rinzu
const clip: Scissor
```

### field first

[source](../src/macos.rinzu#L4111).

```rinzu
const first: Int
```

### field count

[source](../src/macos.rinzu#L4112).

```rinzu
count: Int
```

## rinzu.macos.Buffer

class · [source](../src/macos.rinzu#L15).

```rinzu
class Buffer
```

### field handle

[source](../src/macos.rinzu#L16).

```rinzu
const handle: BufferHandle
```

## rinzu.macos.Buffer.destroy

Checked type: `fn(Buffer)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L30).

```rinzu
fn destroy(self: Buffer) -> Int
```

## rinzu.macos.Buffer.read

Checked type: `fn(Buffer,Int,Int)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L25).

```rinzu
fn read(self: Buffer, offset: Int, length: Int) -> ByteArray
```

## rinzu.macos.Buffer.write

Checked type: `fn(Buffer,Int,ByteArray)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L18).

```rinzu
fn write(self: Buffer, offset: Int, bytes: ByteArray) -> Int
```

## rinzu.macos.Buffer.writeQuad2D

Checked type: `fn(Buffer,Int,Quad2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L38).

```rinzu
fn writeQuad2D(self: Buffer, index: Int, quad: Quad2D) -> Int
```

## rinzu.macos.Buffer.writeVertex2D

Checked type: `fn(Buffer,Int,Vertex2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L34).

```rinzu
fn writeVertex2D(self: Buffer, index: Int, vertex: Vertex2D) -> Int
```

## rinzu.macos.BufferHandle

Checked type: `BufferHandle`.

opaque · [source](../src/macos.rinzu#L1481).

```rinzu
opaque BufferHandle;
```

## rinzu.macos.Button

class · [source](../src/macos.rinzu#L3338).

```rinzu
class Button
```

### field view

[source](../src/macos.rinzu#L3339).

```rinzu
const view: View
```

## rinzu.macos.Button.destroy

Checked type: `fn(Button)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3345).

```rinzu
fn destroy(self: Button) -> Int
```

## rinzu.macos.Button.identity

Checked type: `fn(Button)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3341).

```rinzu
fn identity(self: Button) -> Int
```

## rinzu.macos.Button.setEnabled

Checked type: `fn(Button,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3349).

```rinzu
fn setEnabled(self: Button, enabled: Bool) -> Int
```

## rinzu.macos.Button.setText

Checked type: `fn(Button,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3357).

```rinzu
fn setText(self: Button, value: String) -> Int
```

## rinzu.macos.Button.text

Checked type: `fn(Button)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3353).

```rinzu
fn text(self: Button) -> String
```

## rinzu.macos.Canvas2D

class · [source](../src/macos.rinzu#L4543).

```rinzu
class Canvas2D
```

### field view

[source](../src/macos.rinzu#L4544).

```rinzu
const view: View
```

### field viewId

[source](../src/macos.rinzu#L4545).

```rinzu
const viewId: Int
```

### field clock

[source](../src/macos.rinzu#L4546).

```rinzu
const clock: FrameClock
```

### field batch

[source](../src/macos.rinzu#L4547).

```rinzu
const batch: Batch2D
```

### field task

[source](../src/macos.rinzu#L4548).

```rinzu
task: Option<UiTask>
```

### field clear

[source](../src/macos.rinzu#L4549).

```rinzu
clear: Color
```

### field frames

[source](../src/macos.rinzu#L4550).

```rinzu
frames: Int
```

### field drawing

[source](../src/macos.rinzu#L4551).

```rinzu
drawing: Bool
```

### field stopped

[source](../src/macos.rinzu#L4552).

```rinzu
stopped: Bool
```

### field disposed

[source](../src/macos.rinzu#L4553).

```rinzu
disposed: Bool
```

## rinzu.macos.Canvas2D.invalidate

Checked type: `fn(Canvas2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4555).

```rinzu
fn invalidate(self: Canvas2D) -> Int
```

## rinzu.macos.Canvas2D.setAnimating

Checked type: `fn(Canvas2D,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4562).

```rinzu
fn setAnimating(self: Canvas2D, enabled: Bool) -> Int
```

## rinzu.macos.Canvas2D.setClear

Checked type: `fn(Canvas2D,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4569).

```rinzu
fn setClear(self: Canvas2D, color: Color)
```

## rinzu.macos.Canvas2D.stop

Checked type: `fn(Canvas2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4574).

```rinzu
fn stop(self: Canvas2D)
```

## rinzu.macos.CanvasOptions

class · [source](../src/macos.rinzu#L4523).

```rinzu
class CanvasOptions
```

### field capacity

[source](../src/macos.rinzu#L4524).

```rinzu
capacity: Int
```

### field fps

[source](../src/macos.rinzu#L4525).

```rinzu
fps: Int
```

### field clear

[source](../src/macos.rinzu#L4526).

```rinzu
clear: Color
```

### field displayPaced

[source](../src/macos.rinzu#L4527).

```rinzu
displayPaced: Bool
```

### field pixelFormat

[source](../src/macos.rinzu#L4529).

```rinzu
pixelFormat: Int
```

Metal surface format. Use pixelBGRA8 or pixelBGRA8Srgb.

## rinzu.macos.CanvasOptions.create

Checked type: `fn(Int,Int,Color)->CanvasOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L4531).

```rinzu
fn create(capacity: Int, fps: Int, clear: Color) -> CanvasOptions
```

## rinzu.macos.Checkbox

class · [source](../src/macos.rinzu#L3364).

```rinzu
class Checkbox
```

### field view

[source](../src/macos.rinzu#L3365).

```rinzu
const view: View
```

## rinzu.macos.Checkbox.checked

Checked type: `fn(Checkbox)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3387).

```rinzu
fn checked(self: Checkbox) -> Bool
```

## rinzu.macos.Checkbox.destroy

Checked type: `fn(Checkbox)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3371).

```rinzu
fn destroy(self: Checkbox) -> Int
```

## rinzu.macos.Checkbox.identity

Checked type: `fn(Checkbox)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3367).

```rinzu
fn identity(self: Checkbox) -> Int
```

## rinzu.macos.Checkbox.setChecked

Checked type: `fn(Checkbox,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3392).

```rinzu
fn setChecked(self: Checkbox, value: Bool) -> Int
```

## rinzu.macos.Checkbox.setEnabled

Checked type: `fn(Checkbox,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3375).

```rinzu
fn setEnabled(self: Checkbox, enabled: Bool) -> Int
```

## rinzu.macos.Checkbox.setText

Checked type: `fn(Checkbox,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3383).

```rinzu
fn setText(self: Checkbox, value: String) -> Int
```

## rinzu.macos.Checkbox.text

Checked type: `fn(Checkbox)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3379).

```rinzu
fn text(self: Checkbox) -> String
```

## rinzu.macos.Color

Checked type: `Color`.

native-record · [source](../src/macos.rinzu#L1512).

```rinzu
record Color
```

### field red

[source](../src/macos.rinzu#L1513).

```rinzu
red: Float
```

### field green

[source](../src/macos.rinzu#L1514).

```rinzu
green: Float
```

### field blue

[source](../src/macos.rinzu#L1515).

```rinzu
blue: Float
```

### field alpha

[source](../src/macos.rinzu#L1516).

```rinzu
alpha: Float
```

## rinzu.macos.Command

class · [source](../src/macos.rinzu#L63).

```rinzu
class Command
```

### field handle

[source](../src/macos.rinzu#L64).

```rinzu
const handle: CommandHandle
```

## rinzu.macos.Command.abandon

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L128).

```rinzu
fn abandon(self: Command) -> Int
```

## rinzu.macos.Command.beginCompute

Checked type: `fn(Command,ComputePipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L66).

```rinzu
fn beginCompute(self: Command, pipeline: ComputePipeline) -> Int
```

## rinzu.macos.Command.beginRender

Checked type: `fn(Command,View,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L70).

```rinzu
fn beginRender(self: Command, view: View, clear: Color) -> Int
```

## rinzu.macos.Command.beginRenderMatching

Checked type: `fn(Command,View,Color,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L76).

```rinzu
fn beginRenderMatching(self: Command, view: View, clear: Color, width: Int, height: Int) -> Int
```

Admit only a drawable matching a previously captured pixel extent.
A resize mismatch is retryable (-7810); the command remains idle and unleased.

## rinzu.macos.Command.beginRenderTexture

Checked type: `fn(Command,Texture,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L140).

```rinzu
fn beginRenderTexture(self: Command, texture: Texture, clear: Color) -> Int
```

## rinzu.macos.Command.commit

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L124).

```rinzu
fn commit(self: Command) -> Int
```

## rinzu.macos.Command.destroy

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L136).

```rinzu
fn destroy(self: Command) -> Int
```

## rinzu.macos.Command.dispatch

Checked type: `fn(Command,Int,Int,Int,Int,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L108).

```rinzu
fn dispatch(self: Command, x: Int, y: Int, z: Int, tx: Int, ty: Int, tz: Int) -> Int
```

## rinzu.macos.Command.drawTriangles

Checked type: `fn(Command,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L112).

```rinzu
fn drawTriangles(self: Command, start: Int, count: Int) -> Int
```

## rinzu.macos.Command.drawTrianglesInstanced

Checked type: `fn(Command,Int,Int,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L117).

```rinzu
fn drawTrianglesInstanced(self: Command, start: Int, count: Int, instances: Int, baseInstance: Int) -> Int
```

Instance IDs include baseInstance. The caller bounds its shader's buffer access.

## rinzu.macos.Command.setComputeBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L87).

```rinzu
fn setComputeBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setComputeSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L168).

```rinzu
fn setComputeSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setComputeTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L153).

```rinzu
fn setComputeTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setFragmentBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L101).

```rinzu
fn setFragmentBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setFragmentSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L176).

```rinzu
fn setFragmentSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setFragmentTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L161).

```rinzu
fn setFragmentTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setRenderPipeline

Checked type: `fn(Command,RenderPipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L83).

```rinzu
fn setRenderPipeline(self: Command, pipeline: RenderPipeline) -> Int
```

## rinzu.macos.Command.setScissor

Checked type: `fn(Command,Scissor)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L149).

```rinzu
fn setScissor(self: Command, scissor: Scissor) -> Int
```

## rinzu.macos.Command.setVertexBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L94).

```rinzu
fn setVertexBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setVertexSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L172).

```rinzu
fn setVertexSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setVertexTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L157).

```rinzu
fn setVertexTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setViewport

Checked type: `fn(Command,Rect)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L145).

```rinzu
fn setViewport(self: Command, viewport: Rect) -> Int
```

Render state uses pixels with top-left origin, independently of AppKit points.

## rinzu.macos.Command.wait

Checked type: `async(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L132).

```rinzu
async fn wait(self: Command) -> Int
```

## rinzu.macos.CommandHandle

Checked type: `CommandHandle`.

opaque · [source](../src/macos.rinzu#L1499).

```rinzu
opaque CommandHandle;
```

## rinzu.macos.ComputePipeline

class · [source](../src/macos.rinzu#L184).

```rinzu
class ComputePipeline
```

### field handle

[source](../src/macos.rinzu#L185).

```rinzu
const handle: ComputePipelineHandle
```

## rinzu.macos.ComputePipeline.destroy

Checked type: `fn(ComputePipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L187).

```rinzu
fn destroy(self: ComputePipeline) -> Int
```

## rinzu.macos.ComputePipelineHandle

Checked type: `ComputePipelineHandle`.

opaque · [source](../src/macos.rinzu#L1495).

```rinzu
opaque ComputePipelineHandle;
```

## rinzu.macos.DataColumn

class · [source](../src/macos.rinzu#L4926).

```rinzu
class DataColumn
```

### field title

[source](../src/macos.rinzu#L4927).

```rinzu
const title: String
```

### field width

[source](../src/macos.rinzu#L4928).

```rinzu
const width: Float
```

### field sortable

[source](../src/macos.rinzu#L4929).

```rinzu
const sortable: Bool
```

## rinzu.macos.DataRow

class · [source](../src/macos.rinzu#L4949).

```rinzu
class DataRow
```

IDs are positive and unique. A tree parent must precede its children; zero is a root.

### field id

[source](../src/macos.rinzu#L4950).

```rinzu
const id: Int
```

### field parent

[source](../src/macos.rinzu#L4951).

```rinzu
const parent: Int
```

### field cells

[source](../src/macos.rinzu#L4952).

```rinzu
const cells: List<String>
```

## rinzu.macos.DataState

Checked type: `DataState`.

native-record · [source](../src/macos.rinzu#L4851).

```rinzu
record DataState
```

### field rows

[source](../src/macos.rinzu#L4852).

```rinzu
rows: Int
```

### field visibleRows

[source](../src/macos.rinzu#L4853).

```rinzu
visibleRows: Int
```

### field cellViews

[source](../src/macos.rinzu#L4854).

```rinzu
cellViews: Int
```

### field bytes

[source](../src/macos.rinzu#L4855).

```rinzu
bytes: Int
```

### field revision

[source](../src/macos.rinzu#L4856).

```rinzu
revision: Int
```

### field selectedId

[source](../src/macos.rinzu#L4857).

```rinzu
selectedId: Int
```

### field selectedRow

[source](../src/macos.rinzu#L4858).

```rinzu
selectedRow: Int
```

### field firstVisible

[source](../src/macos.rinzu#L4859).

```rinzu
firstVisible: Int
```

### field lastVisible

[source](../src/macos.rinzu#L4860).

```rinzu
lastVisible: Int
```

### field pendingRows

[source](../src/macos.rinzu#L4861).

```rinzu
pendingRows: Int
```

## rinzu.macos.DataView

class · [source](../src/macos.rinzu#L4956).

```rinzu
class DataView
```

Shared List/Table/Tree interface. Model and AppKit datasource contain native copies only.

### field view

[source](../src/macos.rinzu#L4957).

```rinzu
const view: View
```

### field columns

[source](../src/macos.rinzu#L4958).

```rinzu
const columns: Int
```

### field control

[source](../src/macos.rinzu#L4959).

```rinzu
const control: UiControl
```

## rinzu.macos.DataView.accepts

Checked type: `fn(DataView,UiEvent)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4987).

```rinzu
fn accepts(self: DataView, event: UiEvent) -> Bool
```

Sort requests address a column. Row events must match the current model revision.

## rinzu.macos.DataView.cell

Checked type: `fn(DataView,Int,Int)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5064).

```rinzu
fn cell(self: DataView, id: Int, column: Int) -> String
```

## rinzu.macos.DataView.destroy

Checked type: `fn(DataView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4965).

```rinzu
fn destroy(self: DataView) -> Int
```

## rinzu.macos.DataView.generateRows

Checked type: `async(DataView,Int,$rinzu_closure_530a103bc12515a3)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5078).

```rinzu
async fn generateRows(self: DataView, count: Int, make: fn (Int) -> DataRow)
```

Build offscreen, yield every 256 rows, and publish one complete model.

## rinzu.macos.DataView.identity

Checked type: `fn(DataView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4961).

```rinzu
fn identity(self: DataView) -> Int
```

## rinzu.macos.DataView.isExpanded

Checked type: `fn(DataView,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5056).

```rinzu
fn isExpanded(self: DataView, id: Int) -> Bool
```

## rinzu.macos.DataView.scrollTo

Checked type: `fn(DataView,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5048).

```rinzu
fn scrollTo(self: DataView, id: Int) -> Int
```

## rinzu.macos.DataView.select

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4998).

```rinzu
fn select(self: DataView, id: Int, reveal: Bool) -> Int
```

## rinzu.macos.DataView.selectIds

Checked type: `fn(DataView,List<Int>,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5003).

```rinzu
fn selectIds(self: DataView, ids: List<Int>, reveal: Bool) -> Int
```

Replace the selection with stable row IDs. An empty list clears it.

## rinzu.macos.DataView.selectedIds

Checked type: `fn(DataView)->List<Int>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5024).

```rinzu
fn selectedIds(self: DataView) -> List<Int>
```

Owned selected IDs in visible row order.

## rinzu.macos.DataView.setExpanded

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5052).

```rinzu
fn setExpanded(self: DataView, id: Int, expanded: Bool) -> Int
```

## rinzu.macos.DataView.setRows

Checked type: `async(DataView,List<DataRow>)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5109).

```rinzu
async fn setRows(self: DataView, rows: List<DataRow>)
```

## rinzu.macos.DataView.sort

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L5060).

```rinzu
fn sort(self: DataView, column: Int, ascending: Bool) -> Int
```

## rinzu.macos.DataView.state

Checked type: `fn(DataView)->DataState`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4969).

```rinzu
fn state(self: DataView) -> DataState
```

## rinzu.macos.DataViewOptions

class · [source](../src/macos.rinzu#L4932).

```rinzu
class DataViewOptions
```

### field rowHeight

[source](../src/macos.rinzu#L4933).

```rinzu
rowHeight: Float
```

### field allowsMultipleSelection

[source](../src/macos.rinzu#L4934).

```rinzu
allowsMultipleSelection: Bool
```

### field alternatingRowColors

[source](../src/macos.rinzu#L4935).

```rinzu
alternatingRowColors: Bool
```

### field applicationSort

[source](../src/macos.rinzu#L4936).

```rinzu
applicationSort: Bool
```

## rinzu.macos.DataViewOptions.create

Checked type: `fn()->DataViewOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L4938).

```rinzu
fn create() -> DataViewOptions
```

## rinzu.macos.Device

class · [source](../src/macos.rinzu#L192).

```rinzu
class Device
```

### field handle

[source](../src/macos.rinzu#L193).

```rinzu
const handle: DeviceHandle
```

## rinzu.macos.Device.allocateBuffer

Checked type: `fn(Device,Int)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L201).

```rinzu
fn allocateBuffer(self: Device, length: Int) -> Buffer
```

## rinzu.macos.Device.batch2D

Checked type: `fn(Device,Int)->Batch2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L270).

```rinzu
fn batch2D(self: Device, capacity: Int) -> Batch2D
```

## rinzu.macos.Device.buffer

Checked type: `fn(Device,ByteArray)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L195).

```rinzu
fn buffer(self: Device, bytes: ByteArray) -> Buffer
```

## rinzu.macos.Device.command

Checked type: `fn(Device)->Command`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L232).

```rinzu
fn command(self: Device) -> Command
```

Allocate a reusable command handle, normally once per in-flight frame slot.

## rinzu.macos.Device.destroy

Checked type: `fn(Device)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L236).

```rinzu
fn destroy(self: Device) -> Int
```

## rinzu.macos.Device.imageTexture

Checked type: `fn(Device,ByteArray)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L250).

```rinzu
fn imageTexture(self: Device, encoded: ByteArray) -> Texture
```

Decode frame zero, normalize EXIF orientation and premultiplied sRGB RGBA8.
Encoded input <=64 MiB, dimensions <=8192, decoded pixels <=256 MiB.

## rinzu.macos.Device.isAvailable

Checked type: `fn(Device)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L223).

```rinzu
fn isAvailable(self: Device) -> Bool
```

## rinzu.macos.Device.library

Checked type: `fn(Device,String)->Library`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L205).

```rinzu
fn library(self: Device, source: String) -> Library
```

## rinzu.macos.Device.loadImageTexture

Checked type: `async(Device,String)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L372).

```rinzu
async fn loadImageTexture(self: Device, path: String) -> Texture
```

Stream the encoded file with a 64 MiB limit, then decode on Main.
Decode/upload is synchronous; cooperative async decode is a later extension.

## rinzu.macos.Device.loadLibrary

Checked type: `fn(Device,String)->Library`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L214).

```rinzu
fn loadLibrary(self: Device, path: String) -> Library
```

## rinzu.macos.Device.rasterText

Checked type: `fn(Device,TextLayout,Float)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L377).

```rinzu
fn rasterText(self: Device, layout: TextLayout, scale: Float) -> Texture
```

## rinzu.macos.Device.sampler

Checked type: `fn(Device,Int,Int)->Sampler`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L258).

```rinzu
fn sampler(self: Device, filter: Int, address: Int) -> Sampler
```

## rinzu.macos.Device.surface

Checked type: `fn(Device,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L227).

```rinzu
fn surface(self: Device, rect: Rect) -> View
```

## rinzu.macos.Device.text2D

Checked type: `fn(Device,Font,String,Float,Int,Float)->Text2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L383).

```rinzu
fn text2D(self: Device, font: Font, text: String, width: Float, alignment: Int, scale: Float) -> Text2D
```

## rinzu.macos.Device.texture2D

Checked type: `fn(Device,Int,Int,Int,Int)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L242).

```rinzu
fn texture2D(self: Device, width: Int, height: Int, format: Int, usage: Int) -> Texture
```

Single-level RGBA8, BGRA8, R8 or Alpha8 unorm storage. Usage combines distinct flags.
Alpha8 samples coverage as (a,a,a,a); it supports sampled/storage usage, not render targets.

## rinzu.macos.Device.vertexBuffer2D

Checked type: `fn(Device,Int)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L263).

```rinzu
fn vertexBuffer2D(self: Device, capacity: Int) -> Buffer
```

Allocate packed float32 x,y,u,v,r,g,b,a vertices (32 bytes each).

## rinzu.macos.DeviceHandle

Checked type: `DeviceHandle`.

opaque · [source](../src/macos.rinzu#L1479).

```rinzu
opaque DeviceHandle;
```

## rinzu.macos.Document

class · [source](../src/document.rinzu#L123).

```rinzu
class Document
```

Source document state. Native input updates this model without echoing setText.
Public mutations finish synchronously under cancellation masking.

### field undo

[source](../src/document.rinzu#L127).

```rinzu
const undo: DocumentHistory
```

### field redo

[source](../src/document.rinzu#L128).

```rinzu
const redo: DocumentHistory
```

### field text

[source](../src/document.rinzu#L129).

```rinzu
text: String
```

### field start

[source](../src/document.rinzu#L130).

```rinzu
start: Int
```

### field end

[source](../src/document.rinzu#L131).

```rinzu
end: Int
```

### field version

[source](../src/document.rinzu#L132).

```rinzu
version: Int
```

### field savedVersion

[source](../src/document.rinzu#L133).

```rinzu
savedVersion: Int
```

### field accepting

[source](../src/document.rinzu#L134).

```rinzu
accepting: Bool
```

### field edits

[source](../src/document.rinzu#L135).

```rinzu
edits: Int
```

## rinzu.macos.Document.accepts

Checked type: `fn(document::Document,document::DocumentSnapshot)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L323).

```rinzu
fn accepts(self: Document, snapshot: DocumentSnapshot) -> Bool
```

## rinzu.macos.Document.create

Checked type: `fn(String,Bool)->document::Document`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L137).

```rinzu
fn create(text: String, saved: Bool) -> Document
```

## rinzu.macos.Document.dirty

Checked type: `fn(document::Document)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L202).

```rinzu
fn dirty(self: Document) -> Bool
```

## rinzu.macos.Document.edit

Checked type: `fn(document::Document,String,Int,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L228).

```rinzu
fn edit(self: Document, text: String, start: Int, end: Int) -> Bool
```

## rinzu.macos.Document.markSaved

Checked type: `fn(document::Document,document::DocumentSnapshot)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L312).

```rinzu
fn markSaved(self: Document, snapshot: DocumentSnapshot)
```

## rinzu.macos.Document.redoEdit

Checked type: `fn(document::Document)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L284).

```rinzu
fn redoEdit(self: Document) -> Bool
```

## rinzu.macos.Document.reset

Checked type: `fn(document::Document,String,Bool)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L177).

```rinzu
fn reset(self: Document, text: String, saved: Bool) -> Bool
```

Install another document after its read succeeds; invalidate outstanding snapshots.

## rinzu.macos.Document.select

Checked type: `fn(document::Document,Int,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L213).

```rinzu
fn select(self: Document, start: Int, end: Int)
```

## rinzu.macos.Document.snapshot

Checked type: `fn(document::Document)->document::DocumentSnapshot`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L165).

```rinzu
fn snapshot(self: Document) -> DocumentSnapshot
```

## rinzu.macos.Document.undoEdit

Checked type: `fn(document::Document)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L256).

```rinzu
fn undoEdit(self: Document) -> Bool
```

## rinzu.macos.Document.withHistory

Checked type: `fn(String,Bool,Int,Int)->document::Document`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L141).

```rinzu
fn withHistory(text: String, saved: Bool, maximumEntries: Int, maximumBytes: Int) -> Document
```

## rinzu.macos.DocumentBinding

class · [source](../src/macos.rinzu#L3674).

```rinzu
class DocumentBinding
```

A Source document bound to an existing TextView. The Window owns the native View.

### field session

[source](../src/macos.rinzu#L3675).

```rinzu
const session: Session
```

### field input

[source](../src/macos.rinzu#L3676).

```rinzu
const input: TextView
```

### field document

[source](../src/macos.rinzu#L3677).

```rinzu
const document: documents.Document
```

### field barrier

[source](../src/macos.rinzu#L3678).

```rinzu
barrier: Int
```

## rinzu.macos.DocumentBinding.capture

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3691).

```rinzu
fn capture(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentBinding.create

Checked type: `fn(Session,TextView,document::Document)->DocumentBinding`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3680).

```rinzu
fn create(session: Session, input: TextView, document: documents.Document) -> DocumentBinding
```

## rinzu.macos.DocumentBinding.load

Checked type: `fn(DocumentBinding,String)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3703).

```rinzu
fn load(self: DocumentBinding, text: String) -> Bool
```

Replace the document after a successful load, with fresh history and version.

## rinzu.macos.DocumentBinding.receive

Checked type: `fn(DocumentBinding,UiEvent)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3729).

```rinzu
fn receive(self: DocumentBinding, event: UiEvent) -> Bool
```

## rinzu.macos.DocumentBinding.redoEdit

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3800).

```rinzu
fn redoEdit(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentBinding.replace

Checked type: `fn(DocumentBinding,String,Int,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3749).

```rinzu
fn replace(self: DocumentBinding, text: String, start: Int, end: Int) -> Bool
```

## rinzu.macos.DocumentBinding.setAccepting

Checked type: `fn(DocumentBinding,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3825).

```rinzu
fn setAccepting(self: DocumentBinding, accepting: Bool) -> Int
```

## rinzu.macos.DocumentBinding.undoEdit

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3775).

```rinzu
fn undoEdit(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentHistory

class · [source](../src/document.rinzu#L19).

```rinzu
class DocumentHistory
```

### field maximumEntries

[source](../src/document.rinzu#L20).

```rinzu
const maximumEntries: Int
```

### field maximumBytes

[source](../src/document.rinzu#L21).

```rinzu
const maximumBytes: Int
```

### field entries

[source](../src/document.rinzu#L22).

```rinzu
entries: List<DocumentSnapshot>
```

### field bytes

[source](../src/document.rinzu#L23).

```rinzu
bytes: Int
```

## rinzu.macos.DocumentHistory.clear

Checked type: `fn(document::DocumentHistory)->Unit`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L32).

```rinzu
fn clear(self: DocumentHistory)
```

## rinzu.macos.DocumentHistory.create

Checked type: `fn(Int,Int)->document::DocumentHistory`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L25).

```rinzu
fn create(maximumEntries: Int, maximumBytes: Int) -> DocumentHistory
```

## rinzu.macos.DocumentHistory.length

Checked type: `fn(document::DocumentHistory)->Int`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L44).

```rinzu
fn length(self: DocumentHistory) -> Int
```

## rinzu.macos.DocumentHistory.peek

Checked type: `fn(document::DocumentHistory)->Option<document::DocumentSnapshot>`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L48).

```rinzu
fn peek(self: DocumentHistory) -> Option<DocumentSnapshot>
```

## rinzu.macos.DocumentHistory.pop

Checked type: `fn(document::DocumentHistory)->Option<document::DocumentSnapshot>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L55).

```rinzu
fn pop(self: DocumentHistory) -> Option<DocumentSnapshot>
```

## rinzu.macos.DocumentHistory.push

Checked type: `fn(document::DocumentHistory,document::DocumentSnapshot)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L84).

```rinzu
fn push(self: DocumentHistory, snapshot: DocumentSnapshot)
```

## rinzu.macos.DocumentSnapshot

class · [source](../src/document.rinzu#L10).

```rinzu
class DocumentSnapshot
```

Immutable, transferable input for saving and background analysis.

### field documentId

[source](../src/document.rinzu#L11).

```rinzu
const documentId: Int
```

### field generation

[source](../src/document.rinzu#L12).

```rinzu
const generation: Int
```

### field text

[source](../src/document.rinzu#L13).

```rinzu
const text: String
```

### field start

[source](../src/document.rinzu#L14).

```rinzu
const start: Int
```

### field end

[source](../src/document.rinzu#L15).

```rinzu
const end: Int
```

### field version

[source](../src/document.rinzu#L16).

```rinzu
const version: Int
```

## rinzu.macos.Environment

Checked type: `Environment`.

native-record · [source](../src/macos.rinzu#L1527).

```rinzu
record Environment
```

### field generation

[source](../src/macos.rinzu#L1528).

```rinzu
generation: Int
```

### field fontGeneration

[source](../src/macos.rinzu#L1529).

```rinzu
fontGeneration: Int
```

### field preferences

[source](../src/macos.rinzu#L1530).

```rinzu
preferences: Int
```

### field observing

[source](../src/macos.rinzu#L1531).

```rinzu
observing: CBool
```

## rinzu.macos.Event

Checked type: `Event`.

native-record · [source](../src/macos.rinzu#L1633).

```rinzu
record Event
```

### field kind

[source](../src/macos.rinzu#L1634).

```rinzu
kind: Int
```

### field windowId

[source](../src/macos.rinzu#L1635).

```rinzu
windowId: Int
```

### field viewId

[source](../src/macos.rinzu#L1636).

```rinzu
viewId: Int
```

### field sequence

[source](../src/macos.rinzu#L1637).

```rinzu
sequence: Int
```

### field x

[source](../src/macos.rinzu#L1638).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1639).

```rinzu
y: Float
```

### field width

[source](../src/macos.rinzu#L1640).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1641).

```rinzu
height: Float
```

### field scale

[source](../src/macos.rinzu#L1642).

```rinzu
scale: Float
```

### field keyCode

[source](../src/macos.rinzu#L1643).

```rinzu
keyCode: Int
```

### field modifiers

[source](../src/macos.rinzu#L1644).

```rinzu
modifiers: Int
```

### field action

[source](../src/macos.rinzu#L1645).

```rinzu
action: Int
```

### field selectionStart

[source](../src/macos.rinzu#L1646).

```rinzu
selectionStart: Int
```

### field selectionEnd

[source](../src/macos.rinzu#L1647).

```rinzu
selectionEnd: Int
```

### field flags

[source](../src/macos.rinzu#L1648).

```rinzu
flags: Int
```

### field value

[source](../src/macos.rinzu#L1649).

```rinzu
value: Float
```

### field deltaX

[source](../src/macos.rinzu#L1650).

```rinzu
deltaX: Float
```

### field deltaY

[source](../src/macos.rinzu#L1651).

```rinzu
deltaY: Float
```

## rinzu.macos.Font

class · [source](../src/macos.rinzu#L408).

```rinzu
class Font
```

### field handle

[source](../src/macos.rinzu#L409).

```rinzu
const handle: FontHandle
```

## rinzu.macos.Font.destroy

Checked type: `fn(Font)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L465).

```rinzu
fn destroy(self: Font) -> Int
```

## rinzu.macos.Font.info

Checked type: `fn(Font) throws(Error)->{axes:List<{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}>,family:String,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},postscriptName:String,size:Float,traits:Int,version:Int}`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L412).

```rinzu
fn info(self: Font) throws(Error) -> textValues.FontInfo
```

Actual selected face, matrix and active variation values. Traits: bold=1, italic=2, mono=4, color=8.

## rinzu.macos.Font.layout

Checked type: `fn(Font,String,Float,Int)->TextLayout`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L439).

```rinzu
fn layout(self: Font, text: String, width: Float, alignment: Int) -> TextLayout
```

UTF8 <=64 KiB. Width zero is natural; positive width wraps. Alignment 0/1/2.

## rinzu.macos.Font.metrics

Checked type: `fn(Font)->FontMetrics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L452).

```rinzu
fn metrics(self: Font) -> FontMetrics
```

Unrounded CoreText face metrics in logical font points.

## rinzu.macos.Font.shape

Checked type: `fn(Font,String,Bool) throws(Error)->TextLayout`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L429).

```rinzu
fn shape(self: Font, text: String, ligatures: Bool) throws(Error) -> TextLayout
```

Shape one unwrapped CoreText line (UTF-8 <=64 KiB, advance <=8192 points).
Runs preserve CoreText visual order; cluster indices are UTF-16, not grapheme or cell indices.

## rinzu.macos.Font.withTraits

Checked type: `fn(Font,Int) throws(Error)->Font`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L418).

```rinzu
fn withTraits(self: Font, traits: Int) throws(Error) -> Font
```

Resolve real bold/italic traits (0..3), failing if CoreText cannot supply them.

## rinzu.macos.Font.withVariation

Checked type: `fn(Font,Int,Float) throws(Error)->Font`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L423).

```rinzu
fn withVariation(self: Font, identifier: Int, value: Float) throws(Error) -> Font
```

Derive a face with one supported axis value. The original face is unchanged.

## rinzu.macos.FontAxis

Checked type: `{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}`.

type-alias · [source](../src/text.rinzu#L17).

```rinzu
type FontAxis = {
    identifier: Int,
    minimum: Float,
    maximum: Float,
    initial: Float,
    value: Float,
    name: String
};
```

## rinzu.macos.FontCatalog

Checked type: `{faces:List<{family:String,postscriptName:String,traits:Int}>,version:Int}`.

type-alias · [source](../src/text.rinzu#L42).

```rinzu
type FontCatalog = { version: Int, faces: List<FontFace> };
```

## rinzu.macos.FontFace

Checked type: `{family:String,postscriptName:String,traits:Int}`.

type-alias · [source](../src/text.rinzu#L36).

```rinzu
type FontFace = {
    postscriptName: String,
    family: String,
    traits: Int
};
```

## rinzu.macos.FontHandle

Checked type: `FontHandle`.

opaque · [source](../src/macos.rinzu#L1487).

```rinzu
opaque FontHandle;
```

## rinzu.macos.FontInfo

Checked type: `{axes:List<{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}>,family:String,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},postscriptName:String,size:Float,traits:Int,version:Int}`.

type-alias · [source](../src/text.rinzu#L26).

```rinzu
type FontInfo = {
    version: Int,
    postscriptName: String,
    family: String,
    size: Float,
    traits: Int,
    matrix: FontMatrix,
    axes: List<FontAxis>
};
```

## rinzu.macos.FontMatrix

Checked type: `{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float}`.

type-alias · [source](../src/text.rinzu#L8).

```rinzu
type FontMatrix = {
    a: Float,
    b: Float,
    c: Float,
    d: Float,
    tx: Float,
    ty: Float
};
```

Immutable, owned CoreText snapshots. Indices use UTF-16 code units, ranges are half-open.

## rinzu.macos.FontMetrics

Checked type: `FontMetrics`.

native-record · [source](../src/macos.rinzu#L1562).

```rinzu
record FontMetrics
```

### field ascent

[source](../src/macos.rinzu#L1563).

```rinzu
ascent: Float
```

### field descent

[source](../src/macos.rinzu#L1564).

```rinzu
descent: Float
```

### field leading

[source](../src/macos.rinzu#L1565).

```rinzu
leading: Float
```

### field underlinePosition

[source](../src/macos.rinzu#L1566).

```rinzu
underlinePosition: Float
```

### field underlineThickness

[source](../src/macos.rinzu#L1567).

```rinzu
underlineThickness: Float
```

### field unitsPerEm

[source](../src/macos.rinzu#L1568).

```rinzu
unitsPerEm: Int
```

## rinzu.macos.Frame2D

class · [source](../src/macos.rinzu#L4508).

```rinzu
class Frame2D
```

A frame begins in AppKit points / top-left; usePixels restores Batch2D pixel units.

### field info

[source](../src/macos.rinzu#L4509).

```rinzu
const info: FrameInfo
```

### field batch

[source](../src/macos.rinzu#L4510).

```rinzu
const batch: Batch2D
```

### field width

[source](../src/macos.rinzu#L4511).

```rinzu
const width: Float
```

### field height

[source](../src/macos.rinzu#L4512).

```rinzu
const height: Float
```

## rinzu.macos.Frame2D.usePixels

Checked type: `fn(Frame2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4514).

```rinzu
fn usePixels(self: Frame2D)
```

## rinzu.macos.Frame2D.usePoints

Checked type: `fn(Frame2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4518).

```rinzu
fn usePoints(self: Frame2D)
```

## rinzu.macos.FrameClock

class · [source](../src/macos.rinzu#L470).

```rinzu
class FrameClock
```

### field handle

[source](../src/macos.rinzu#L471).

```rinzu
const handle: FrameClockHandle
```

## rinzu.macos.FrameClock.destroy

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L493).

```rinzu
fn destroy(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.invalidate

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L473).

```rinzu
fn invalidate(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.next

Checked type: `async(FrameClock)->Option<FrameInfo>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L519).

```rinzu
async fn next(self: FrameClock) -> Option<FrameInfo>
```

One reader. Cancellation disarms this wait and acknowledges physical publication.

## rinzu.macos.FrameClock.presented

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L485).

```rinzu
fn presented(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.retry

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L481).

```rinzu
fn retry(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.setAnimating

Checked type: `fn(FrameClock,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L477).

```rinzu
fn setAnimating(self: FrameClock, enabled: Bool) -> Int
```

## rinzu.macos.FrameClock.statistics

Checked type: `fn(FrameClock)->FrameStatistics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L503).

```rinzu
fn statistics(self: FrameClock) -> FrameStatistics
```

## rinzu.macos.FrameClock.stop

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L489).

```rinzu
fn stop(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.timing

Checked type: `fn(FrameClock)->FrameTiming`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L497).

```rinzu
fn timing(self: FrameClock) -> FrameTiming
```

## rinzu.macos.FrameClockHandle

Checked type: `FrameClockHandle`.

opaque · [source](../src/macos.rinzu#L1491).

```rinzu
opaque FrameClockHandle;
```

## rinzu.macos.FrameInfo

Checked type: `FrameInfo`.

native-record · [source](../src/macos.rinzu#L1534).

```rinzu
record FrameInfo
```

### field sequence

[source](../src/macos.rinzu#L1535).

```rinzu
sequence: Int
```

### field width

[source](../src/macos.rinzu#L1536).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1537).

```rinzu
height: Int
```

### field scale

[source](../src/macos.rinzu#L1538).

```rinzu
scale: Float
```

### field time

[source](../src/macos.rinzu#L1539).

```rinzu
time: Float
```

### field delta

[source](../src/macos.rinzu#L1540).

```rinzu
delta: Float
```

## rinzu.macos.FrameStatistics

Checked type: `FrameStatistics`.

native-record · [source](../src/macos.rinzu#L1551).

```rinzu
record FrameStatistics
```

### field requests

[source](../src/macos.rinzu#L1552).

```rinzu
requests: Int
```

### field coalesced

[source](../src/macos.rinzu#L1553).

```rinzu
coalesced: Int
```

### field ticks

[source](../src/macos.rinzu#L1554).

```rinzu
ticks: Int
```

### field retries

[source](../src/macos.rinzu#L1555).

```rinzu
retries: Int
```

### field pending

[source](../src/macos.rinzu#L1556).

```rinzu
pending: CBool
```

### field visible

[source](../src/macos.rinzu#L1557).

```rinzu
visible: CBool
```

### field animating

[source](../src/macos.rinzu#L1558).

```rinzu
animating: CBool
```

### field stopped

[source](../src/macos.rinzu#L1559).

```rinzu
stopped: CBool
```

## rinzu.macos.FrameTiming

Checked type: `FrameTiming`.

native-record · [source](../src/macos.rinzu#L1543).

```rinzu
record FrameTiming
```

### field source

[source](../src/macos.rinzu#L1544).

```rinzu
source: Int
```

### field maximumFPS

[source](../src/macos.rinzu#L1545).

```rinzu
maximumFPS: Int
```

### field timestamp

[source](../src/macos.rinzu#L1546).

```rinzu
timestamp: Float
```

### field targetTimestamp

[source](../src/macos.rinzu#L1547).

```rinzu
targetTimestamp: Float
```

### field period

[source](../src/macos.rinzu#L1548).

```rinzu
period: Float
```

## rinzu.macos.InputGrid

Checked type: `{lines:List<ByteArray>,scale:Float,xEdges:List<Int>,yEdges:List<Int>}`.

type-alias · [source](../src/input.rinzu#L46).

```rinzu
type InputGrid = {
    xEdges: List<Int>,
    yEdges: List<Int>,
    scale: Float,
    lines: List<ByteArray>
};
```

Pixel edges at the given scale, with one immutable cluster sequence per
visual line. Each pair of bytes gives a positive UTF-16 length and a
width in cells. Clusters cover the text in order, starting at the first
horizontal edge of each line. Zero-width clusters can describe newlines.

## rinzu.macos.InputPacket

Checked type: `{button:Int,buttons:Int,clicks:Int,command:String,deltaX:Float,deltaY:Float,epoch:Int,flags:Int,keyCode:Int,keyType:Int,kind:Int,modifiers:Int,momentum:Int,phase:Int,rangeBase:Int,replacementLength:Int,replacementStart:Int,revision:Int,selectionLength:Int,selectionStart:Int,source:String,text:String,unmodified:String,version:Int,x:Float,y:Float}`.

type-alias · [source](../src/input.rinzu#L58).

```rinzu
type InputPacket = {
    version: Int,
    kind: Int,
    epoch: Int,
    keyCode: Int,
    revision: Int,
    rangeBase: Int,
    keyType: Int,
    modifiers: Int,
    flags: Int,
    text: String,
    unmodified: String,
    source: String,
    command: String,
    selectionStart: Int,
    selectionLength: Int,
    replacementStart: Int,
    replacementLength: Int,
    x: Float,
    y: Float,
    button: Int,
    buttons: Int,
    clicks: Int,
    deltaX: Float,
    deltaY: Float,
    phase: Int,
    momentum: Int
};
```

The epoch is copied when AppKit produces the event, not when Rinzu reads it.
kind: key-down/up 1/2, marked 3, insert 4, unmark 5, command 6, overflow 7,
pointer down/up/move 8/9/10, scroll 11, focus 12, AX selection request 13,
modifier change 14. Key flags: repeat=1, interpreted=2, replaced-mark=4.
Scroll flags: precise=1. keyType preserves the original NSEvent type.

## rinzu.macos.InputSnapshot

Checked type: `{ack:Int,caretHeight:Float,caretWidth:Float,caretX:Float,caretY:Float,enabled:Bool,epoch:Int,focused:Bool,inputLength:Int,inputStart:Int,markedLength:Int,markedStart:Int,raw:Bool,rawCodes:List<Int>,rawModifiers:Int,revision:Int,selectedLength:Int,selectedStart:Int,spans:List<{height:Float,length:Int,line:Int,start:Int,width:Float,x:Float,y:Float}>,text:String}`.

type-alias · [source](../src/input.rinzu#L19).

```rinzu
type InputSnapshot = {
    epoch: Int,
    revision: Int,
    ack: Int,
    text: String,
    selectedStart: Int,
    selectedLength: Int,
    inputStart: Int,
    inputLength: Int,
    markedStart: Int,
    markedLength: Int,
    caretX: Float,
    caretY: Float,
    caretWidth: Float,
    caretHeight: Float,
    spans: List<InputSpan>,
    enabled: Bool,
    focused: Bool,
    raw: Bool,
    rawModifiers: Int,
    rawCodes: List<Int>
};
```

## rinzu.macos.InputSpan

Checked type: `{height:Float,length:Int,line:Int,start:Int,width:Float,x:Float,y:Float}`.

type-alias · [source](../src/input.rinzu#L9).

```rinzu
type InputSpan = {
    start: Int,
    length: Int,
    x: Float,
    y: Float,
    width: Float,
    height: Float,
    line: Int
};
```

UTF-16 intervals and logical points with top-left view origin. Spans are
nonoverlapping text clusters in document order; line is a visual line index.

## rinzu.macos.InputState

Checked type: `InputState`.

native-record · [source](../src/macos.rinzu#L5324).

```rinzu
record InputState
```

### field epoch

[source](../src/macos.rinzu#L5325).

```rinzu
epoch: Int
```

### field selectedStart

[source](../src/macos.rinzu#L5326).

```rinzu
selectedStart: Int
```

### field selectedLength

[source](../src/macos.rinzu#L5327).

```rinzu
selectedLength: Int
```

### field markedStart

[source](../src/macos.rinzu#L5328).

```rinzu
markedStart: Int
```

### field markedLength

[source](../src/macos.rinzu#L5329).

```rinzu
markedLength: Int
```

### field x

[source](../src/macos.rinzu#L5330).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L5331).

```rinzu
y: Float
```

### field width

[source](../src/macos.rinzu#L5332).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L5333).

```rinzu
height: Float
```

### field enabled

[source](../src/macos.rinzu#L5334).

```rinzu
enabled: CBool
```

### field focused

[source](../src/macos.rinzu#L5335).

```rinzu
focused: CBool
```

### field composing

[source](../src/macos.rinzu#L5336).

```rinzu
composing: CBool
```

## rinzu.macos.Label

class · [source](../src/macos.rinzu#L3312).

```rinzu
class Label
```

### field view

[source](../src/macos.rinzu#L3313).

```rinzu
const view: View
```

## rinzu.macos.Label.destroy

Checked type: `fn(Label)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3319).

```rinzu
fn destroy(self: Label) -> Int
```

## rinzu.macos.Label.identity

Checked type: `fn(Label)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3315).

```rinzu
fn identity(self: Label) -> Int
```

## rinzu.macos.Label.setEnabled

Checked type: `fn(Label,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3323).

```rinzu
fn setEnabled(self: Label, enabled: Bool) -> Int
```

## rinzu.macos.Label.setText

Checked type: `fn(Label,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3331).

```rinzu
fn setText(self: Label, value: String) -> Int
```

## rinzu.macos.Label.text

Checked type: `fn(Label)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3327).

```rinzu
fn text(self: Label) -> String
```

## rinzu.macos.LayoutItem

class · [source](../src/macos.rinzu#L4733).

```rinzu
class LayoutItem
```

Fixed extent plus a nonnegative proportional share of remaining space.

### field view

[source](../src/macos.rinzu#L4734).

```rinzu
const view: View
```

### field fixed

[source](../src/macos.rinzu#L4735).

```rinzu
const fixed: Float
```

### field grow

[source](../src/macos.rinzu#L4736).

```rinzu
const grow: Float
```

## rinzu.macos.Library

class · [source](../src/macos.rinzu#L549).

```rinzu
class Library
```

### field handle

[source](../src/macos.rinzu#L550).

```rinzu
const handle: LibraryHandle
```

## rinzu.macos.Library.computePipeline

Checked type: `fn(Library,String)->ComputePipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L552).

```rinzu
fn computePipeline(self: Library, name: String) -> ComputePipeline
```

## rinzu.macos.Library.destroy

Checked type: `fn(Library)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L580).

```rinzu
fn destroy(self: Library) -> Int
```

## rinzu.macos.Library.renderPipeline

Checked type: `fn(Library,String,String)->RenderPipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L561).

```rinzu
fn renderPipeline(self: Library, vertex: String, fragment: String) -> RenderPipeline
```

## rinzu.macos.Library.renderPipelineWithOptions

Checked type: `fn(Library,String,String,Int,Int)->RenderPipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L584).

```rinzu
fn renderPipelineWithOptions(self: Library, vertex: String, fragment: String, format: Int, blend: Int)
        -> RenderPipeline
```

## rinzu.macos.LibraryHandle

Checked type: `LibraryHandle`.

opaque · [source](../src/macos.rinzu#L1493).

```rinzu
opaque LibraryHandle;
```

## rinzu.macos.Menu

class · [source](../src/macos.rinzu#L599).

```rinzu
class Menu
```

### field handle

[source](../src/macos.rinzu#L600).

```rinzu
const handle: MenuHandle
```

## rinzu.macos.Menu.addAction

Checked type: `fn(Menu,String,Int,String,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L602).

```rinzu
fn addAction(self: Menu, title: String, action: Int, key: String, modifiers: Int) -> Int
```

## rinzu.macos.Menu.addSeparator

Checked type: `fn(Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L646).

```rinzu
fn addSeparator(self: Menu) -> Int
```

## rinzu.macos.Menu.addStandard

Checked type: `fn(Menu,String,Int,String,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L622).

```rinzu
fn addStandard(self: Menu, title: String, command: Int, key: String, modifiers: Int) -> Int
```

## rinzu.macos.Menu.addSubmenu

Checked type: `fn(Menu,Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L642).

```rinzu
fn addSubmenu(self: Menu, child: Menu) -> Int
```

## rinzu.macos.Menu.destroy

Checked type: `fn(Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L654).

```rinzu
fn destroy(self: Menu) -> Int
```

## rinzu.macos.Menu.setState

Checked type: `fn(Menu,Int,Bool,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L650).

```rinzu
fn setState(self: Menu, action: Int, enabled: Bool, isChecked: Bool) -> Int
```

## rinzu.macos.MenuHandle

Checked type: `MenuHandle`.

opaque · [source](../src/macos.rinzu#L1501).

```rinzu
opaque MenuHandle;
```

## rinzu.macos.OpenPanelOptions

class · [source](../src/macos.rinzu#L1204).

```rinzu
class OpenPanelOptions
```

### field title

[source](../src/macos.rinzu#L1205).

```rinzu
title: String
```

### field directory

[source](../src/macos.rinzu#L1206).

```rinzu
directory: String
```

### field contentTypes

[source](../src/macos.rinzu#L1207).

```rinzu
contentTypes: List<String>
```

### field canChooseFiles

[source](../src/macos.rinzu#L1208).

```rinzu
canChooseFiles: Bool
```

### field canChooseDirectories

[source](../src/macos.rinzu#L1209).

```rinzu
canChooseDirectories: Bool
```

### field allowsMultipleSelection

[source](../src/macos.rinzu#L1210).

```rinzu
allowsMultipleSelection: Bool
```

### field canCreateDirectories

[source](../src/macos.rinzu#L1211).

```rinzu
canCreateDirectories: Bool
```

## rinzu.macos.OpenPanelOptions.create

Checked type: `fn(String,String)->OpenPanelOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1213).

```rinzu
fn create(title: String, directory: String) -> OpenPanelOptions
```

## rinzu.macos.Quad2D

class · [source](../src/macos.rinzu#L3995).

```rinzu
class Quad2D
```

Six vertices per quad; quad index (not a byte or vertex offset).

### field destination

[source](../src/macos.rinzu#L3996).

```rinzu
const destination: Rect
```

### field uv

[source](../src/macos.rinzu#L3997).

```rinzu
const uv: Rect
```

### field tint

[source](../src/macos.rinzu#L3998).

```rinzu
const tint: Color
```

### field transform

[source](../src/macos.rinzu#L3999).

```rinzu
const transform: Transform2D
```

## rinzu.macos.Rect

Checked type: `Rect`.

native-record · [source](../src/macos.rinzu#L1505).

```rinzu
record Rect
```

### field x

[source](../src/macos.rinzu#L1506).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1507).

```rinzu
y: Float
```

### field width

[source](../src/macos.rinzu#L1508).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1509).

```rinzu
height: Float
```

## rinzu.macos.RenderPipeline

class · [source](../src/macos.rinzu#L659).

```rinzu
class RenderPipeline
```

### field handle

[source](../src/macos.rinzu#L660).

```rinzu
const handle: RenderPipelineHandle
```

## rinzu.macos.RenderPipeline.destroy

Checked type: `fn(RenderPipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L662).

```rinzu
fn destroy(self: RenderPipeline) -> Int
```

## rinzu.macos.RenderPipelineHandle

Checked type: `RenderPipelineHandle`.

opaque · [source](../src/macos.rinzu#L1497).

```rinzu
opaque RenderPipelineHandle;
```

## rinzu.macos.RunContext

Checked type: `{session:Session}`.

type-alias · [source](../src/macos.rinzu#L1470).

```rinzu
type RunContext = { session: Session };
```

## rinzu.macos.Sampler

class · [source](../src/macos.rinzu#L667).

```rinzu
class Sampler
```

### field handle

[source](../src/macos.rinzu#L668).

```rinzu
const handle: SamplerHandle
```

## rinzu.macos.Sampler.destroy

Checked type: `fn(Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L670).

```rinzu
fn destroy(self: Sampler) -> Int
```

## rinzu.macos.SamplerHandle

Checked type: `SamplerHandle`.

opaque · [source](../src/macos.rinzu#L1485).

```rinzu
opaque SamplerHandle;
```

## rinzu.macos.SavePanelOptions

class · [source](../src/macos.rinzu#L1226).

```rinzu
class SavePanelOptions
```

### field title

[source](../src/macos.rinzu#L1227).

```rinzu
title: String
```

### field directory

[source](../src/macos.rinzu#L1228).

```rinzu
directory: String
```

### field name

[source](../src/macos.rinzu#L1229).

```rinzu
name: String
```

### field contentTypes

[source](../src/macos.rinzu#L1230).

```rinzu
contentTypes: List<String>
```

### field canCreateDirectories

[source](../src/macos.rinzu#L1231).

```rinzu
canCreateDirectories: Bool
```

## rinzu.macos.SavePanelOptions.create

Checked type: `fn(String,String,String)->SavePanelOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1233).

```rinzu
fn create(title: String, directory: String, name: String) -> SavePanelOptions
```

## rinzu.macos.Scissor

Checked type: `Scissor`.

native-record · [source](../src/macos.rinzu#L1626).

```rinzu
record Scissor
```

### field x

[source](../src/macos.rinzu#L1627).

```rinzu
x: Int
```

### field y

[source](../src/macos.rinzu#L1628).

```rinzu
y: Int
```

### field width

[source](../src/macos.rinzu#L1629).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1630).

```rinzu
height: Int
```

## rinzu.macos.ScrollView

class · [source](../src/macos.rinzu#L3538).

```rinzu
class ScrollView
```

### field view

[source](../src/macos.rinzu#L3539).

```rinzu
const view: View
```

## rinzu.macos.ScrollView.destroy

Checked type: `fn(ScrollView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3545).

```rinzu
fn destroy(self: ScrollView) -> Int
```

## rinzu.macos.ScrollView.identity

Checked type: `fn(ScrollView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3541).

```rinzu
fn identity(self: ScrollView) -> Int
```

## rinzu.macos.ScrollView.scrollTo

Checked type: `fn(ScrollView,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3557).

```rinzu
fn scrollTo(self: ScrollView, x: Float, y: Float) -> Int
```

## rinzu.macos.ScrollView.setContent

Checked type: `fn(ScrollView,View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3553).

```rinzu
fn setContent(self: ScrollView, content: View) -> Int
```

## rinzu.macos.ScrollView.setEnabled

Checked type: `fn(ScrollView,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3549).

```rinzu
fn setEnabled(self: ScrollView, enabled: Bool) -> Int
```

## rinzu.macos.ScrollView.visibleRect

Checked type: `fn(ScrollView)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3561).

```rinzu
fn visibleRect(self: ScrollView) -> Rect
```

## rinzu.macos.Selection

Checked type: `Selection`.

native-record · [source](../src/macos.rinzu#L1684).

```rinzu
record Selection
```

### field start

[source](../src/macos.rinzu#L1685).

```rinzu
start: Int
```

### field end

[source](../src/macos.rinzu#L1686).

```rinzu
end: Int
```

## rinzu.macos.Session

class · [source](../src/macos.rinzu#L675).

```rinzu
class Session
```

### field handle

[source](../src/macos.rinzu#L676).

```rinzu
const handle: SessionHandle
```

## rinzu.macos.Session.button

Checked type: `fn(Session,String,Rect,Int)->Button`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L786).

```rinzu
fn button(self: Session, title: String, frame: Rect, action: Int) -> Button
```

## rinzu.macos.Session.checkbox

Checked type: `fn(Session,String,Rect,Int)->Checkbox`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L790).

```rinzu
fn checkbox(self: Session, title: String, frame: Rect, action: Int) -> Checkbox
```

## rinzu.macos.Session.clipboardText

Checked type: `fn(Session)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L815).

```rinzu
fn clipboardText(self: Session) -> String
```

## rinzu.macos.Session.close

Checked type: `async(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L778).

```rinzu
async fn close(self: Session) -> Int
```

## rinzu.macos.Session.device

Checked type: `fn(Session)->Device`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L766).

```rinzu
fn device(self: Session) -> Device
```

## rinzu.macos.Session.environment

Checked type: `fn(Session)->Environment`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L689).

```rinzu
fn environment(self: Session) -> Environment
```

## rinzu.macos.Session.eventSequence

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L829).

```rinzu
fn eventSequence(self: Session) -> Int
```

Sequence barrier for reconciling a native snapshot with already queued input.

## rinzu.macos.Session.font

Checked type: `fn(Session,String,Float,Bool)->Font`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L839).

```rinzu
fn font(self: Session, name: String, size: Float, bold: Bool) -> Font
```

## rinzu.macos.Session.fontCatalog

Checked type: `fn(Session) throws(Error)->{faces:List<{family:String,postscriptName:String,traits:Int}>,version:Int}`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L834).

```rinzu
fn fontCatalog(self: Session) throws(Error) -> textValues.FontCatalog
```

Snapshot the installed font descriptors. Selection and cache policy belong to the caller.

## rinzu.macos.Session.isRunning

Checked type: `fn(Session)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L717).

```rinzu
fn isRunning(self: Session) -> Bool
```

## rinzu.macos.Session.label

Checked type: `fn(Session,String,Rect)->Label`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L782).

```rinzu
fn label(self: Session, title: String, frame: Rect) -> Label
```

## rinzu.macos.Session.nextEvent

Checked type: `async(Session)->UiEvent`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L730).

```rinzu
async fn nextEvent(self: Session) -> UiEvent
```

## rinzu.macos.Session.observeEnvironment

Checked type: `fn(Session,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L685).

```rinzu
fn observeEnvironment(self: Session, enabled: Bool) -> Int
```

Owned absolute app-resource root; None in an ordinary JIT/console host.

## rinzu.macos.Session.openURL

Checked type: `fn(Session,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L679).

```rinzu
fn openURL(self: Session, url: String) -> Int
```

The owner validates allowed schemes and user intent before requesting OS dispatch.

## rinzu.macos.Session.resourcePath

Checked type: `fn(Session,String)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L704).

```rinzu
fn resourcePath(self: Session, relative: String) -> String
```

Resolve a normalized app-relative resource name without changing cwd.

## rinzu.macos.Session.resourceRoot

Checked type: `fn(Session)->Option<String>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L695).

```rinzu
fn resourceRoot(self: Session) -> Option<String>
```

## rinzu.macos.Session.run

Checked type: `async(Session,fn($rinzu_record_f7c713f12e29ebb74f67222ddd835128,Event)->Unit)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L770).

```rinzu
async fn run(self: Session, handler: fn (RunContext, Event) -> Unit) -> Int
```

## rinzu.macos.Session.runEvents

Checked type: `fn(Session)->Future<Int>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L721).

```rinzu
fn runEvents(self: Session) -> Future<Int>
```

## rinzu.macos.Session.scrollView

Checked type: `fn(Session,Rect)->ScrollView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L806).

```rinzu
fn scrollView(self: Session, frame: Rect) -> ScrollView
```

## rinzu.macos.Session.setActivationPolicy

Checked type: `fn(Session,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L758).

```rinzu
fn setActivationPolicy(self: Session, policy: Int) -> Int
```

Set the process activation policy used for this session's windows.

## rinzu.macos.Session.setClipboardText

Checked type: `fn(Session,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L810).

```rinzu
fn setClipboardText(self: Session, value: String) -> Int
```

## rinzu.macos.Session.setEventOverflowRecovery

Checked type: `fn(Session,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L726).

```rinzu
fn setEventOverflowRecovery(self: Session, enabled: Bool) -> Int
```

On overflow, keep intake active and deliver eventOverflow. Configure before starting the run loop.

## rinzu.macos.Session.stop

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L774).

```rinzu
fn stop(self: Session) -> Int
```

## rinzu.macos.Session.textField

Checked type: `fn(Session,String,Rect,Int)->TextField`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L794).

```rinzu
fn textField(self: Session, title: String, frame: Rect, action: Int) -> TextField
```

## rinzu.macos.Session.textView

Checked type: `fn(Session,String,Rect)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L798).

```rinzu
fn textView(self: Session, title: String, frame: Rect) -> TextView
```

## rinzu.macos.Session.textViewWithOptions

Checked type: `fn(Session,String,Rect,TextViewOptions)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L802).

```rinzu
fn textViewWithOptions(self: Session, title: String, frame: Rect, options: TextViewOptions) -> TextView
```

## rinzu.macos.Session.view

Checked type: `fn(Session,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L762).

```rinzu
fn view(self: Session, rect: Rect) -> View
```

## rinzu.macos.Session.window

Checked type: `fn(Session,String,Float,Float)->Window`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L734).

```rinzu
fn window(self: Session, title: String, width: Float, height: Float) -> Window
```

## rinzu.macos.Session.windowWithOptions

Checked type: `fn(Session,String,WindowOptions)->Window`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L743).

```rinzu
fn windowWithOptions(self: Session, title: String, options: WindowOptions) -> Window
```

## rinzu.macos.SessionHandle

Checked type: `SessionHandle`.

opaque · [source](../src/macos.rinzu#L1473).

```rinzu
opaque SessionHandle;
```

## rinzu.macos.Statistics

Checked type: `Statistics`.

native-record · [source](../src/macos.rinzu#L1654).

```rinzu
record Statistics
```

### field sessions

[source](../src/macos.rinzu#L1655).

```rinzu
sessions: Int
```

### field windows

[source](../src/macos.rinzu#L1656).

```rinzu
windows: Int
```

### field views

[source](../src/macos.rinzu#L1657).

```rinzu
views: Int
```

### field devices

[source](../src/macos.rinzu#L1658).

```rinzu
devices: Int
```

### field buffers

[source](../src/macos.rinzu#L1659).

```rinzu
buffers: Int
```

### field libraries

[source](../src/macos.rinzu#L1660).

```rinzu
libraries: Int
```

### field pipelines

[source](../src/macos.rinzu#L1661).

```rinzu
pipelines: Int
```

### field commands

[source](../src/macos.rinzu#L1662).

```rinzu
commands: Int
```

### field bufferBytes

[source](../src/macos.rinzu#L1663).

```rinzu
bufferBytes: Int
```

### field retainedControls

[source](../src/macos.rinzu#L1664).

```rinzu
retainedControls: Int
```

### field queuedEvents

[source](../src/macos.rinzu#L1665).

```rinzu
queuedEvents: Int
```

### field eventPayloadBytes

[source](../src/macos.rinzu#L1666).

```rinzu
eventPayloadBytes: Int
```

### field snapshotBytes

[source](../src/macos.rinzu#L1667).

```rinzu
snapshotBytes: Int
```

### field sheets

[source](../src/macos.rinzu#L1668).

```rinzu
sheets: Int
```

### field sheetBytes

[source](../src/macos.rinzu#L1669).

```rinzu
sheetBytes: Int
```

### field textures

[source](../src/macos.rinzu#L1670).

```rinzu
textures: Int
```

### field samplers

[source](../src/macos.rinzu#L1671).

```rinzu
samplers: Int
```

### field textureBytes

[source](../src/macos.rinzu#L1672).

```rinzu
textureBytes: Int
```

### field fonts

[source](../src/macos.rinzu#L1673).

```rinzu
fonts: Int
```

### field textLayouts

[source](../src/macos.rinzu#L1674).

```rinzu
textLayouts: Int
```

### field textBytes

[source](../src/macos.rinzu#L1675).

```rinzu
textBytes: Int
```

### field frameClocks

[source](../src/macos.rinzu#L1676).

```rinzu
frameClocks: Int
```

### field frameTimers

[source](../src/macos.rinzu#L1677).

```rinzu
frameTimers: Int
```

### field frameWaiters

[source](../src/macos.rinzu#L1678).

```rinzu
frameWaiters: Int
```

### field dataRows

[source](../src/macos.rinzu#L1679).

```rinzu
dataRows: Int
```

### field dataBytes

[source](../src/macos.rinzu#L1680).

```rinzu
dataBytes: Int
```

### field dataUpdates

[source](../src/macos.rinzu#L1681).

```rinzu
dataUpdates: Int
```

## rinzu.macos.Text2D

class · [source](../src/macos.rinzu#L4464).

```rinzu
class Text2D
```

Reusable text snapshot. Keep it across frames; reraster only after text/style changes.

### field layout

[source](../src/macos.rinzu#L4465).

```rinzu
const layout: TextLayout
```

### field texture

[source](../src/macos.rinzu#L4466).

```rinzu
const texture: Texture
```

### field metrics

[source](../src/macos.rinzu#L4467).

```rinzu
const metrics: TextMetrics
```

### field scale

[source](../src/macos.rinzu#L4468).

```rinzu
const scale: Float
```

### field width

[source](../src/macos.rinzu#L4469).

```rinzu
const width: Int
```

### field height

[source](../src/macos.rinzu#L4470).

```rinzu
const height: Int
```

## rinzu.macos.Text2D.destroy

Checked type: `fn(Text2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4472).

```rinzu
fn destroy(self: Text2D)
```

## rinzu.macos.TextField

class · [source](../src/macos.rinzu#L3403).

```rinzu
class TextField
```

### field view

[source](../src/macos.rinzu#L3404).

```rinzu
const view: View
```

## rinzu.macos.TextField.destroy

Checked type: `fn(TextField)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3410).

```rinzu
fn destroy(self: TextField) -> Int
```

## rinzu.macos.TextField.identity

Checked type: `fn(TextField)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3406).

```rinzu
fn identity(self: TextField) -> Int
```

## rinzu.macos.TextField.isComposing

Checked type: `fn(TextField)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3434).

```rinzu
fn isComposing(self: TextField) -> Bool
```

## rinzu.macos.TextField.select

Checked type: `fn(TextField,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3430).

```rinzu
fn select(self: TextField, start: Int, end: Int) -> Int
```

## rinzu.macos.TextField.selection

Checked type: `fn(TextField)->Selection`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3426).

```rinzu
fn selection(self: TextField) -> Selection
```

## rinzu.macos.TextField.setEnabled

Checked type: `fn(TextField,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3414).

```rinzu
fn setEnabled(self: TextField, enabled: Bool) -> Int
```

## rinzu.macos.TextField.setText

Checked type: `fn(TextField,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3422).

```rinzu
fn setText(self: TextField, value: String) -> Int
```

## rinzu.macos.TextField.text

Checked type: `fn(TextField)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3418).

```rinzu
fn text(self: TextField) -> String
```

## rinzu.macos.TextGlyph

Checked type: `{advanceX:Float,advanceY:Float,end:Int,identity:Int,start:Int,x:Float,y:Float}`.

type-alias · [source](../src/text.rinzu#L44).

```rinzu
type TextGlyph = {
    identity: Int,
    start: Int,
    end: Int,
    x: Float,
    y: Float,
    advanceX: Float,
    advanceY: Float
};
```

## rinzu.macos.TextLayout

class · [source](../src/macos.rinzu#L849).

```rinzu
class TextLayout
```

### field handle

[source](../src/macos.rinzu#L850).

```rinzu
const handle: TextLayoutHandle
```

## rinzu.macos.TextLayout.destroy

Checked type: `fn(TextLayout)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L883).

```rinzu
fn destroy(self: TextLayout) -> Int
```

## rinzu.macos.TextLayout.fragment

Checked type: `fn(TextLayout,Int,Int) throws(Error)->TextLayout`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L861).

```rinzu
fn fragment(self: TextLayout, start: Int, end: Int) throws(Error) -> TextLayout
```

Rasterizable selection retaining the original shaping and face fallback.
Half-open UTF-16 boundaries cannot split a cluster. Coordinates are relative to the first
selected glyph's X position and the baseline (metrics.baseline=0). The selection owns its line.

## rinzu.macos.TextLayout.metrics

Checked type: `fn(TextLayout)->TextMetrics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L865).

```rinzu
fn metrics(self: TextLayout) -> TextMetrics
```

## rinzu.macos.TextLayout.shaping

Checked type: `fn(TextLayout) throws(Error)->{advance:Float,runs:List<{end:Int,font:{axes:List<{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}>,family:String,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},postscriptName:String,size:Float,traits:Int,version:Int},glyphs:List<{advanceX:Float,advanceY:Float,end:Int,identity:Int,start:Int,x:Float,y:Float}>,isFallback:Bool,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},rtl:Bool,start:Int}>,utf16Length:Int,version:Int}`.

Error contract: `throws(Error)` (declared).

method · [source](../src/macos.rinzu#L853).

```rinzu
fn shaping(self: TextLayout) throws(Error) -> textValues.TextShape
```

An owned snapshot independent of this handle's lifetime; only available on shape() layouts.

## rinzu.macos.TextLayoutHandle

Checked type: `TextLayoutHandle`.

opaque · [source](../src/macos.rinzu#L1489).

```rinzu
opaque TextLayoutHandle;
```

## rinzu.macos.TextMetrics

Checked type: `TextMetrics`.

native-record · [source](../src/macos.rinzu#L1571).

```rinzu
record TextMetrics
```

### field width

[source](../src/macos.rinzu#L1572).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1573).

```rinzu
height: Float
```

### field baseline

[source](../src/macos.rinzu#L1574).

```rinzu
baseline: Float
```

### field ascent

[source](../src/macos.rinzu#L1575).

```rinzu
ascent: Float
```

### field descent

[source](../src/macos.rinzu#L1576).

```rinzu
descent: Float
```

### field leading

[source](../src/macos.rinzu#L1577).

```rinzu
leading: Float
```

### field left

[source](../src/macos.rinzu#L1578).

```rinzu
left: Float
```

### field top

[source](../src/macos.rinzu#L1579).

```rinzu
top: Float
```

### field rasterWidth

[source](../src/macos.rinzu#L1580).

```rinzu
rasterWidth: Float
```

### field rasterHeight

[source](../src/macos.rinzu#L1581).

```rinzu
rasterHeight: Float
```

### field lines

[source](../src/macos.rinzu#L1582).

```rinzu
lines: Int
```

## rinzu.macos.TextRun

Checked type: `{end:Int,font:{axes:List<{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}>,family:String,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},postscriptName:String,size:Float,traits:Int,version:Int},glyphs:List<{advanceX:Float,advanceY:Float,end:Int,identity:Int,start:Int,x:Float,y:Float}>,isFallback:Bool,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},rtl:Bool,start:Int}`.

type-alias · [source](../src/text.rinzu#L54).

```rinzu
type TextRun = {
    start: Int,
    end: Int,
    rtl: Bool,
    isFallback: Bool,
    font: FontInfo,
    matrix: FontMatrix,
    glyphs: List<TextGlyph>
};
```

## rinzu.macos.TextShape

Checked type: `{advance:Float,runs:List<{end:Int,font:{axes:List<{identifier:Int,initial:Float,maximum:Float,minimum:Float,name:String,value:Float}>,family:String,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},postscriptName:String,size:Float,traits:Int,version:Int},glyphs:List<{advanceX:Float,advanceY:Float,end:Int,identity:Int,start:Int,x:Float,y:Float}>,isFallback:Bool,matrix:{a:Float,b:Float,c:Float,d:Float,tx:Float,ty:Float},rtl:Bool,start:Int}>,utf16Length:Int,version:Int}`.

type-alias · [source](../src/text.rinzu#L64).

```rinzu
type TextShape = {
    version: Int,
    utf16Length: Int,
    advance: Float,
    runs: List<TextRun>
};
```

## rinzu.macos.TextView

class · [source](../src/macos.rinzu#L3474).

```rinzu
class TextView
```

### field view

[source](../src/macos.rinzu#L3475).

```rinzu
const view: View
```

## rinzu.macos.TextView.configure

Checked type: `fn(TextView,TextViewOptions)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3490).

```rinzu
fn configure(self: TextView, options: TextViewOptions) -> Int
```

An empty font name selects a system font.

## rinzu.macos.TextView.destroy

Checked type: `fn(TextView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3481).

```rinzu
fn destroy(self: TextView) -> Int
```

## rinzu.macos.TextView.identity

Checked type: `fn(TextView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3477).

```rinzu
fn identity(self: TextView) -> Int
```

## rinzu.macos.TextView.isComposing

Checked type: `fn(TextView)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3530).

```rinzu
fn isComposing(self: TextView) -> Bool
```

## rinzu.macos.TextView.select

Checked type: `fn(TextView,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3526).

```rinzu
fn select(self: TextView, start: Int, end: Int) -> Int
```

## rinzu.macos.TextView.selection

Checked type: `fn(TextView)->Selection`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3522).

```rinzu
fn selection(self: TextView) -> Selection
```

## rinzu.macos.TextView.setEnabled

Checked type: `fn(TextView,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3485).

```rinzu
fn setEnabled(self: TextView, enabled: Bool) -> Int
```

## rinzu.macos.TextView.setText

Checked type: `fn(TextView,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3518).

```rinzu
fn setText(self: TextView, value: String) -> Int
```

## rinzu.macos.TextView.text

Checked type: `fn(TextView)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3514).

```rinzu
fn text(self: TextView) -> String
```

## rinzu.macos.TextViewOptions

class · [source](../src/macos.rinzu#L3441).

```rinzu
class TextViewOptions
```

### field fontName

[source](../src/macos.rinzu#L3442).

```rinzu
fontName: String
```

### field fontSize

[source](../src/macos.rinzu#L3443).

```rinzu
fontSize: Float
```

### field monospacedSystemFont

[source](../src/macos.rinzu#L3444).

```rinzu
monospacedSystemFont: Bool
```

### field allowsUndo

[source](../src/macos.rinzu#L3445).

```rinzu
allowsUndo: Bool
```

### field automaticQuoteSubstitution

[source](../src/macos.rinzu#L3446).

```rinzu
automaticQuoteSubstitution: Bool
```

### field automaticDashSubstitution

[source](../src/macos.rinzu#L3447).

```rinzu
automaticDashSubstitution: Bool
```

### field automaticTextReplacement

[source](../src/macos.rinzu#L3448).

```rinzu
automaticTextReplacement: Bool
```

## rinzu.macos.TextViewOptions.create

Checked type: `fn()->TextViewOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L3450).

```rinzu
fn create() -> TextViewOptions
```

## rinzu.macos.Texture

class · [source](../src/macos.rinzu#L888).

```rinzu
class Texture
```

### field handle

[source](../src/macos.rinzu#L889).

```rinzu
const handle: TextureHandle
```

## rinzu.macos.Texture.alphaMode

Checked type: `fn(Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L898).

```rinzu
fn alphaMode(self: Texture) -> Int
```

Interpretation used by Batch2D. This metadata does not transform the stored pixels.

## rinzu.macos.Texture.destroy

Checked type: `fn(Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L926).

```rinzu
fn destroy(self: Texture) -> Int
```

## rinzu.macos.Texture.identity

Checked type: `fn(Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L930).

```rinzu
fn identity(self: Texture) -> Int
```

## rinzu.macos.Texture.info

Checked type: `fn(Texture)->TextureInfo`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L891).

```rinzu
fn info(self: Texture) -> TextureInfo
```

## rinzu.macos.Texture.read

Checked type: `fn(Texture,Scissor)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L915).

```rinzu
fn read(self: Texture, region: Scissor) -> ByteArray
```

Tightly packed owned bytes, in the texture's channel order; requires no GPU lease.

## rinzu.macos.Texture.readChannel

Checked type: `fn(Texture,Scissor,Int)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L921).

```rinzu
fn readChannel(self: Texture, region: Scissor, channel: Int) -> ByteArray
```

One stored byte channel (0..3 for RGBA/BGRA, 0 for R8/Alpha8), tightly packed.

## rinzu.macos.Texture.setAlphaMode

Checked type: `fn(Texture,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L903).

```rinzu
fn setAlphaMode(self: Texture, mode: Int) -> Int
```

Declare the input alpha representation. Set it again when replacing pixels in another representation.

## rinzu.macos.Texture.write

Checked type: `fn(Texture,Scissor,Int,ByteArray)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L907).

```rinzu
fn write(self: Texture, region: Scissor, rowBytes: Int, bytes: ByteArray) -> Int
```

## rinzu.macos.TextureHandle

Checked type: `TextureHandle`.

opaque · [source](../src/macos.rinzu#L1483).

```rinzu
opaque TextureHandle;
```

## rinzu.macos.TextureInfo

Checked type: `TextureInfo`.

native-record · [source](../src/macos.rinzu#L1519).

```rinzu
record TextureInfo
```

### field width

[source](../src/macos.rinzu#L1520).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1521).

```rinzu
height: Int
```

### field format

[source](../src/macos.rinzu#L1522).

```rinzu
format: Int
```

### field usage

[source](../src/macos.rinzu#L1523).

```rinzu
usage: Int
```

### field bytes

[source](../src/macos.rinzu#L1524).

```rinzu
bytes: Int
```

## rinzu.macos.Transform2D

Checked type: `Transform2D`.

native-record · [source](../src/macos.rinzu#L1596).

```rinzu
record Transform2D
```

### field a

[source](../src/macos.rinzu#L1597).

```rinzu
a: Float
```

### field b

[source](../src/macos.rinzu#L1598).

```rinzu
b: Float
```

### field c

[source](../src/macos.rinzu#L1599).

```rinzu
c: Float
```

### field d

[source](../src/macos.rinzu#L1600).

```rinzu
d: Float
```

### field tx

[source](../src/macos.rinzu#L1601).

```rinzu
tx: Float
```

### field ty

[source](../src/macos.rinzu#L1602).

```rinzu
ty: Float
```

## rinzu.macos.UiAction

class · [source](../src/macos.rinzu#L4654).

```rinzu
class UiAction
```

Source-only handler storage. A binding admits one active job at a time.

### field action

[source](../src/macos.rinzu#L4655).

```rinzu
const action: Int
```

### field handler

[source](../src/macos.rinzu#L4656).

```rinzu
const handler: fn (UiJob, UiEvent) -> Future<Unit>
```

### field busy

[source](../src/macos.rinzu#L4657).

```rinzu
busy: Bool
```

## rinzu.macos.UiActions

class · [source](../src/macos.rinzu#L4660).

```rinzu
class UiActions
```

### field bindings

[source](../src/macos.rinzu#L4661).

```rinzu
bindings: List<UiAction>
```

## rinzu.macos.UiActions.handle

Checked type: `fn(UiActions,UiScope,UiEvent)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4679).

```rinzu
fn handle(self: UiActions, scope: UiScope, event: UiEvent)
```

## rinzu.macos.UiActions.on

Checked type: `fn(UiActions,Int,$rinzu_closure_735ce3cd6d5e35d7)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4663).

```rinzu
fn on(self: UiActions, action: Int, handler: fn (UiJob, UiEvent) -> Future<Unit>)
```

## rinzu.macos.UiApplication

class · [source](../src/macos.rinzu#L3125).

```rinzu
class UiApplication
```

Application body context. Each Window keeps its own UiScope.

### field session

[source](../src/macos.rinzu#L3126).

```rinzu
const session: Session
```

### field primary

[source](../src/macos.rinzu#L3127).

```rinzu
const primary: UiScope
```

## rinzu.macos.UiControl

class · [source](../src/macos.rinzu#L2573).

```rinzu
class UiControl
```

Shared stop state contains no task handles.

### field stopping

[source](../src/macos.rinzu#L2574).

```rinzu
stopping: Bool
```

### field closed

[source](../src/macos.rinzu#L2575).

```rinzu
closed: Bool
```

## rinzu.macos.UiEvent

class · [source](../src/macos.rinzu#L2295).

```rinzu
class UiEvent
```

An owned event. Text remains valid after the native queue is acknowledged.

### field kind

[source](../src/macos.rinzu#L2296).

```rinzu
const kind: Int
```

### field windowId

[source](../src/macos.rinzu#L2297).

```rinzu
const windowId: Int
```

### field viewId

[source](../src/macos.rinzu#L2298).

```rinzu
const viewId: Int
```

### field sequence

[source](../src/macos.rinzu#L2299).

```rinzu
const sequence: Int
```

### field x

[source](../src/macos.rinzu#L2300).

```rinzu
const x: Float
```

### field y

[source](../src/macos.rinzu#L2301).

```rinzu
const y: Float
```

### field width

[source](../src/macos.rinzu#L2302).

```rinzu
const width: Float
```

### field height

[source](../src/macos.rinzu#L2303).

```rinzu
const height: Float
```

### field scale

[source](../src/macos.rinzu#L2304).

```rinzu
const scale: Float
```

### field keyCode

[source](../src/macos.rinzu#L2305).

```rinzu
const keyCode: Int
```

### field modifiers

[source](../src/macos.rinzu#L2306).

```rinzu
const modifiers: Int
```

### field action

[source](../src/macos.rinzu#L2307).

```rinzu
const action: Int
```

### field selectionStart

[source](../src/macos.rinzu#L2308).

```rinzu
const selectionStart: Int
```

### field selectionEnd

[source](../src/macos.rinzu#L2309).

```rinzu
const selectionEnd: Int
```

### field flags

[source](../src/macos.rinzu#L2310).

```rinzu
const flags: Int
```

### field value

[source](../src/macos.rinzu#L2311).

```rinzu
const value: Float
```

### field deltaX

[source](../src/macos.rinzu#L2312).

```rinzu
const deltaX: Float
```

### field deltaY

[source](../src/macos.rinzu#L2313).

```rinzu
const deltaY: Float
```

### field text

[source](../src/macos.rinzu#L2314).

```rinzu
const text: String
```

## rinzu.macos.UiJob

class · [source](../src/macos.rinzu#L2579).

```rinzu
class UiJob
```

A job receives native UI capabilities and stop state, without the job registry.

### field session

[source](../src/macos.rinzu#L2580).

```rinzu
const session: Session
```

### field window

[source](../src/macos.rinzu#L2581).

```rinzu
const window: Window
```

### field windowId

[source](../src/macos.rinzu#L2582).

```rinzu
const windowId: Int
```

### field control

[source](../src/macos.rinzu#L2583).

```rinzu
const control: UiControl
```

## rinzu.macos.UiJob.isStopping

Checked type: `fn(UiJob)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L2585).

```rinzu
fn isStopping(self: UiJob) -> Bool
```

## rinzu.macos.UiJob.requestStop

Checked type: `fn(UiJob)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2589).

```rinzu
fn requestStop(self: UiJob)
```

## rinzu.macos.UiJob.wake

Checked type: `fn(UiJob)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2594).

```rinzu
fn wake(self: UiJob) -> Int
```

## rinzu.macos.UiScope

class · [source](../src/macos.rinzu#L2603).

```rinzu
class UiScope
```

Main-owned Window resources and Source jobs. Jobs receive a UiJob context.

### field session

[source](../src/macos.rinzu#L2604).

```rinzu
const session: Session
```

### field window

[source](../src/macos.rinzu#L2605).

```rinzu
const window: Window
```

### field windowId

[source](../src/macos.rinzu#L2606).

```rinzu
const windowId: Int
```

### field tasks

[source](../src/macos.rinzu#L2607).

```rinzu
tasks: List<UiTask>
```

### field canvases

[source](../src/macos.rinzu#L2608).

```rinzu
canvases: List<Canvas2D>
```

### field errors

[source](../src/macos.rinzu#L2609).

```rinzu
errors: List<Error>
```

### field reportedErrors

[source](../src/macos.rinzu#L2610).

```rinzu
reportedErrors: Int
```

### field control

[source](../src/macos.rinzu#L2611).

```rinzu
const control: UiControl
```

## rinzu.macos.UiScope.button

Checked type: `fn(UiScope,String,Rect,Int)->Button`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2897).

```rinzu
fn button(self: UiScope, title: String, frame: Rect, action: Int) -> Button
```

## rinzu.macos.UiScope.canvas2D

Checked type: `fn(UiScope,Device,Rect,Int,Int,Color,$rinzu_closure_efe2dcc12b934013)->Canvas2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2737).

```rinzu
fn canvas2D(
        self: UiScope,
        device: Device,
        frame: Rect,
        capacity: Int,
        fps: Int,
        clear: Color,
        draw: fn (Frame2D) -> Future<Unit>
    ) -> Canvas2D
```

A scope-owned drawing job. Draw callbacks stay in Source, never in AppKit.

## rinzu.macos.UiScope.canvas2DWithOptions

Checked type: `fn(UiScope,Device,Rect,CanvasOptions,$rinzu_closure_efe2dcc12b934013)->Canvas2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2749).

```rinzu
fn canvas2DWithOptions(
        self: UiScope,
        device: Device,
        frame: Rect,
        options: CanvasOptions,
        draw: fn (Frame2D) -> Future<Unit>
    ) -> Canvas2D
```

## rinzu.macos.UiScope.checkbox

Checked type: `fn(UiScope,String,Rect,Int)->Checkbox`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2901).

```rinzu
fn checkbox(self: UiScope, title: String, frame: Rect, action: Int) -> Checkbox
```

## rinzu.macos.UiScope.close

Checked type: `async(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2678).

```rinzu
async fn close(self: UiScope) -> Int
```

## rinzu.macos.UiScope.closeCanvas

Checked type: `async(UiScope,Canvas2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2854).

```rinzu
async fn closeCanvas(self: UiScope, canvas: Canvas2D) -> Int
```

Stop and settle an owned canvas, then release its drawable and drawing resources.
Call from outside the canvas's draw callback. The draw callback may call Canvas2D.stop.

## rinzu.macos.UiScope.dispatch

Checked type: `async(UiScope,$rinzu_closure_6d2f0d3cfa7112a6)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2666).

```rinzu
async fn dispatch(self: UiScope, handler: fn (UiScope, UiEvent) -> Future<Unit>)
```

The Application has one reader. Close/quit policy stays in the Source handler.

## rinzu.macos.UiScope.dispatchActions

Checked type: `async(UiScope,UiActions)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2885).

```rinzu
async fn dispatchActions(self: UiScope, actions: UiActions)
```

## rinzu.macos.UiScope.isStopping

Checked type: `fn(UiScope)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L2642).

```rinzu
fn isStopping(self: UiScope) -> Bool
```

## rinzu.macos.UiScope.join

Checked type: `async(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2660).

```rinzu
async fn join(self: UiScope) -> Int
```

Join the current jobs without closing the Window; callers stop job admission first.

## rinzu.macos.UiScope.label

Checked type: `fn(UiScope,String,Rect)->Label`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2893).

```rinzu
fn label(self: UiScope, title: String, frame: Rect) -> Label
```

## rinzu.macos.UiScope.listView

Checked type: `fn(UiScope,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2705).

```rinzu
fn listView(self: UiScope, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.listViewWithOptions

Checked type: `fn(UiScope,Rect,Int,DataViewOptions)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2717).

```rinzu
fn listViewWithOptions(self: UiScope, frame: Rect, action: Int, options: DataViewOptions) -> DataView
```

## rinzu.macos.UiScope.menu

Checked type: `fn(UiScope,String)->Menu`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2921).

```rinzu
fn menu(self: UiScope, title: String) -> Menu
```

## rinzu.macos.UiScope.requestStop

Checked type: `fn(UiScope)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2646).

```rinzu
fn requestStop(self: UiScope)
```

## rinzu.macos.UiScope.scrollView

Checked type: `fn(UiScope,Rect)->ScrollView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2917).

```rinzu
fn scrollView(self: UiScope, frame: Rect) -> ScrollView
```

## rinzu.macos.UiScope.start

Checked type: `fn(UiScope,$rinzu_closure_2671e076e7dc3bc9)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2613).

```rinzu
fn start(self: UiScope, work: fn (UiJob) -> Future<Unit>) -> Int
```

## rinzu.macos.UiScope.surface

Checked type: `fn(UiScope,Device,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2699).

```rinzu
fn surface(self: UiScope, device: Device, frame: Rect) -> View
```

## rinzu.macos.UiScope.tableView

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2709).

```rinzu
fn tableView(self: UiScope, columns: List<DataColumn>, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.tableViewWithOptions

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int,DataViewOptions)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2721).

```rinzu
fn tableViewWithOptions(
        self: UiScope,
        columns: List<DataColumn>,
        frame: Rect,
        action: Int,
        options: DataViewOptions
    ) -> DataView
```

## rinzu.macos.UiScope.textField

Checked type: `fn(UiScope,String,Rect,Int)->TextField`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2905).

```rinzu
fn textField(self: UiScope, title: String, frame: Rect, action: Int) -> TextField
```

## rinzu.macos.UiScope.textView

Checked type: `fn(UiScope,String,Rect)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2909).

```rinzu
fn textView(self: UiScope, title: String, frame: Rect) -> TextView
```

## rinzu.macos.UiScope.textViewWithOptions

Checked type: `fn(UiScope,String,Rect,TextViewOptions)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2913).

```rinzu
fn textViewWithOptions(self: UiScope, title: String, frame: Rect, options: TextViewOptions) -> TextView
```

## rinzu.macos.UiScope.treeView

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2713).

```rinzu
fn treeView(self: UiScope, columns: List<DataColumn>, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.treeViewWithOptions

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int,DataViewOptions)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2731).

```rinzu
fn treeViewWithOptions(self: UiScope, columns: List<DataColumn>, frame: Rect, action: Int, options: DataViewOptions)
        -> DataView
```

## rinzu.macos.UiScope.wake

Checked type: `fn(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2652).

```rinzu
fn wake(self: UiScope) -> Int
```

Wake the single dispatcher after Source state changes outside an input handler.

## rinzu.macos.UiTask

class · [source](../src/macos.rinzu#L2566).

```rinzu
class UiTask
```

A cooperative job registered with a UI scope. Prefer UiScope.start.

### field pending

[source](../src/macos.rinzu#L2567).

```rinzu
pending: Option<Future<Unit>>
```

### field done

[source](../src/macos.rinzu#L2568).

```rinzu
done: Bool
```

### field started

[source](../src/macos.rinzu#L2569).

```rinzu
started: Bool
```

## rinzu.macos.Vertex2D

Checked type: `Vertex2D`.

native-record · [source](../src/macos.rinzu#L1585).

```rinzu
record Vertex2D
```

### field x

[source](../src/macos.rinzu#L1586).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1587).

```rinzu
y: Float
```

### field u

[source](../src/macos.rinzu#L1588).

```rinzu
u: Float
```

### field v

[source](../src/macos.rinzu#L1589).

```rinzu
v: Float
```

### field red

[source](../src/macos.rinzu#L1590).

```rinzu
red: Float
```

### field green

[source](../src/macos.rinzu#L1591).

```rinzu
green: Float
```

### field blue

[source](../src/macos.rinzu#L1592).

```rinzu
blue: Float
```

### field alpha

[source](../src/macos.rinzu#L1593).

```rinzu
alpha: Float
```

## rinzu.macos.View

class · [source](../src/macos.rinzu#L935).

```rinzu
class View
```

### field handle

[source](../src/macos.rinzu#L936).

```rinzu
const handle: ViewHandle
```

## rinzu.macos.View.acknowledgeInput

Checked type: `fn(View,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L978).

```rinzu
fn acknowledgeInput(self: View, epoch: Int, sequence: Int) -> Int
```

## rinzu.macos.View.addSubview

Checked type: `fn(View,View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1061).

```rinzu
fn addSubview(self: View, child: View) -> Int
```

## rinzu.macos.View.convertRect

Checked type: `fn(View,Rect,Int)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1048).

```rinzu
fn convertRect(self: View, rect: Rect, space: Int) -> Rect
```

AppKit view coordinates: 0 to backing, 1 from backing, 2 to screen, 3 from screen.

## rinzu.macos.View.destroy

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1069).

```rinzu
fn destroy(self: View) -> Int
```

## rinzu.macos.View.detachInput

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L970).

```rinzu
fn detachInput(self: View) -> Int
```

## rinzu.macos.View.discardMarkedText

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L974).

```rinzu
fn discardMarkedText(self: View) -> Int
```

## rinzu.macos.View.displayClock

Checked type: `fn(View,Int)->FrameClock`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1140).

```rinzu
fn displayClock(self: View, maximumFPS: Int) -> FrameClock
```

Display-paced callbacks on macOS 14+, deadline fallback on earlier systems.
Hidden/idle clocks retain no active timer or display callback.

## rinzu.macos.View.drawableSize

Checked type: `fn(View)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1117).

```rinzu
fn drawableSize(self: View) -> Rect
```

## rinzu.macos.View.fill

Checked type: `fn(View,View,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1105).

```rinzu
fn fill(self: View, parent: View, inset: Float) -> Int
```

Attach with constant insets and resize width/height with the parent.

## rinzu.macos.View.focus

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1085).

```rinzu
fn focus(self: View) -> Int
```

## rinzu.macos.View.frame

Checked type: `fn(View)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1041).

```rinzu
fn frame(self: View) -> Rect
```

## rinzu.macos.View.frameClock

Checked type: `fn(View,Int)->FrameClock`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1146).

```rinzu
fn frameClock(self: View, fps: Int) -> FrameClock
```

## rinzu.macos.View.identity

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1037).

```rinzu
fn identity(self: View) -> Int
```

## rinzu.macos.View.inputPacket

Checked type: `fn(View,UiEvent)->$rinzu_record_96aa4881bf57c1a9f8c8727785244b2e`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1001).

```rinzu
fn inputPacket(self: View, event: UiEvent) -> inputValues.InputPacket
```

## rinzu.macos.View.inputState

Checked type: `fn(View)->InputState`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L982).

```rinzu
fn inputState(self: View) -> InputState
```

## rinzu.macos.View.isEnabled

Checked type: `fn(View)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1089).

```rinzu
fn isEnabled(self: View) -> Bool
```

## rinzu.macos.View.isHidden

Checked type: `fn(View)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1094).

```rinzu
fn isHidden(self: View) -> Bool
```

## rinzu.macos.View.pixelFormat

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1134).

```rinzu
fn pixelFormat(self: View) -> Int
```

## rinzu.macos.View.publishGridInput

Checked type: `fn(View,$rinzu_record_7cbe9194647772263b53fcaa9ac66647,$rinzu_record_a806a72236e1d3f066c18bf32d3dfdab)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L953).

```rinzu
fn publishGridInput(self: View, snapshot: inputValues.InputSnapshot, grid: inputValues.InputGrid) -> Int
```

Publish an input snapshot with grid geometry. The snapshot's spans
list must be empty; the grid supplies all cluster positions.

## rinzu.macos.View.publishInput

Checked type: `fn(View,$rinzu_record_7cbe9194647772263b53fcaa9ac66647)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L946).

```rinzu
fn publishInput(self: View, snapshot: inputValues.InputSnapshot) -> Int
```

## rinzu.macos.View.removeFromSuperview

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1065).

```rinzu
fn removeFromSuperview(self: View) -> Int
```

## rinzu.macos.View.requestDraw

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1073).

```rinzu
fn requestDraw(self: View) -> Int
```

## rinzu.macos.View.setAccessibility

Checked type: `fn(View,String,String,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1012).

```rinzu
fn setAccessibility(self: View, label: String, help: String, identifier: String) -> Int
```

## rinzu.macos.View.setAutoresizing

Checked type: `fn(View,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1100).

```rinzu
fn setAutoresizing(self: View, mask: Int) -> Int
```

AppKit bits: min-X margin 1, width 2, max-X 4, min-Y 8, height 16, max-Y 32.

## rinzu.macos.View.setCursor

Checked type: `fn(View,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L939).

```rinzu
fn setCursor(self: View, cursor: Int) -> Int
```

0 arrow, 1 text, 2 pointing hand, 3 crosshair; custom views only.

## rinzu.macos.View.setDevice

Checked type: `fn(View,Device)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1126).

```rinzu
fn setDevice(self: View, device: Device) -> Int
```

sRGB formats encode linear render output and declare the surface's color space.
Format changes require physical settlement of all commands using this surface.
Rebind a settled surface without changing its view identity or frame reader.

## rinzu.macos.View.setEnabled

Checked type: `fn(View,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1077).

```rinzu
fn setEnabled(self: View, enabled: Bool) -> Int
```

## rinzu.macos.View.setFrame

Checked type: `fn(View,Rect)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1057).

```rinzu
fn setFrame(self: View, rect: Rect) -> Int
```

## rinzu.macos.View.setHidden

Checked type: `fn(View,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1081).

```rinzu
fn setHidden(self: View, hidden: Bool) -> Int
```

## rinzu.macos.View.setPixelFormat

Checked type: `fn(View,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1130).

```rinzu
fn setPixelFormat(self: View, format: Int) -> Int
```

## rinzu.macos.View.setTooltip

Checked type: `fn(View,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1032).

```rinzu
fn setTooltip(self: View, text: String) -> Int
```

## rinzu.macos.ViewHandle

Checked type: `ViewHandle`.

opaque · [source](../src/macos.rinzu#L1477).

```rinzu
opaque ViewHandle;
```

## rinzu.macos.Window

class · [source](../src/macos.rinzu#L1271).

```rinzu
class Window
```

### field handle

[source](../src/macos.rinzu#L1272).

```rinzu
const handle: WindowHandle
```

## rinzu.macos.Window.alert

Checked type: `async(Window,String,String,String,String,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1366).

```rinzu
async fn alert(self: Window, title: String, message: String, first: String, second: String, third: String) -> Int
```

One to three buttons, numbered 1..3. Empty optional titles omit buttons. Dismissal returns 0.

## rinzu.macos.Window.alertWithOptions

Checked type: `async(Window,AlertOptions)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1403).

```rinzu
async fn alertWithOptions(self: Window, options: AlertOptions) -> Int
```

Present up to sixteen buttons with explicit Return and Escape roles.

## rinzu.macos.Window.command

Checked type: `fn(Window,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1310).

```rinzu
fn command(self: Window, command: Int) -> Int
```

## rinzu.macos.Window.contentView

Checked type: `fn(Window)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1291).

```rinzu
fn contentView(self: Window) -> View
```

## rinzu.macos.Window.destroy

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1295).

```rinzu
fn destroy(self: Window) -> Int
```

## rinzu.macos.Window.dismissSheet

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1437).

```rinzu
fn dismissSheet(self: Window) -> Int
```

Dismiss the current sheet without closing the Window or stopping later sheets.

## rinzu.macos.Window.effectiveTheme

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1465).

```rinzu
fn effectiveTheme(self: Window) -> Int
```

## rinzu.macos.Window.hide

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1445).

```rinzu
fn hide(self: Window) -> Int
```

## rinzu.macos.Window.identity

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1274).

```rinzu
fn identity(self: Window) -> Int
```

## rinzu.macos.Window.menu

Checked type: `fn(Window,String)->Menu`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1299).

```rinzu
fn menu(self: Window, title: String) -> Menu
```

## rinzu.macos.Window.minimize

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1449).

```rinzu
fn minimize(self: Window) -> Int
```

## rinzu.macos.Window.openFile

Checked type: `fn(Window,String,String)->Future<Option<String>>`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1315).

```rinzu
fn openFile(self: Window, title: String, directory: String) -> Future<Option<String>>
```

One file, as an owned absolute path. Cancel returns None. Empty directory uses AppKit's default.

## rinzu.macos.Window.openFiles

Checked type: `async(Window,OpenPanelOptions)->Option<List<String>>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1325).

```rinzu
async fn openFiles(self: Window, options: OpenPanelOptions) -> Option<List<String>>
```

Choose files, directories or both. A successful result owns up to 1024 absolute paths.

## rinzu.macos.Window.restore

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1453).

```rinzu
fn restore(self: Window) -> Int
```

## rinzu.macos.Window.saveFile

Checked type: `fn(Window,String,String,String)->Future<Option<String>>`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1320).

```rinzu
fn saveFile(self: Window, title: String, directory: String, name: String) -> Future<Option<String>>
```

Choose a destination; writing the file remains a separate operation.

## rinzu.macos.Window.saveFileWithOptions

Checked type: `fn(Window,SavePanelOptions)->Future<Option<String>>`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1357).

```rinzu
fn saveFileWithOptions(self: Window, options: SavePanelOptions) -> Future<Option<String>>
```

## rinzu.macos.Window.setContentSize

Checked type: `fn(Window,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1287).

```rinzu
fn setContentSize(self: Window, width: Float, height: Float) -> Int
```

## rinzu.macos.Window.setMenu

Checked type: `fn(Window,Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1306).

```rinzu
fn setMenu(self: Window, menu: Menu) -> Int
```

## rinzu.macos.Window.setMinimumContentSize

Checked type: `fn(Window,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1457).

```rinzu
fn setMinimumContentSize(self: Window, width: Float, height: Float) -> Int
```

## rinzu.macos.Window.setTheme

Checked type: `fn(Window,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1461).

```rinzu
fn setTheme(self: Window, theme: Int) -> Int
```

## rinzu.macos.Window.setTitle

Checked type: `fn(Window,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1282).

```rinzu
fn setTitle(self: Window, title: String) -> Int
```

## rinzu.macos.Window.show

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1278).

```rinzu
fn show(self: Window) -> Int
```

## rinzu.macos.Window.state

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L1441).

```rinzu
fn state(self: Window) -> Int
```

## rinzu.macos.WindowHandle

Checked type: `WindowHandle`.

opaque · [source](../src/macos.rinzu#L1475).

```rinzu
opaque WindowHandle;
```

## rinzu.macos.WindowOptions

class · [source](../src/macos.rinzu#L1168).

```rinzu
class WindowOptions
```

The frame is a content rectangle in AppKit screen points.

### field frame

[source](../src/macos.rinzu#L1169).

```rinzu
frame: Rect
```

### field style

[source](../src/macos.rinzu#L1170).

```rinzu
style: Int
```

### field centered

[source](../src/macos.rinzu#L1171).

```rinzu
centered: Bool
```

### field visible

[source](../src/macos.rinzu#L1172).

```rinzu
visible: Bool
```

### field activateOnShow

[source](../src/macos.rinzu#L1173).

```rinzu
activateOnShow: Bool
```

## rinzu.macos.WindowOptions.create

Checked type: `fn(Float,Float)->WindowOptions`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L1175).

```rinzu
fn create(width: Float, height: Float) -> WindowOptions
```

## rinzu.macos.actionRedo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3594).

```rinzu
let actionRedo = -2;
```

## rinzu.macos.actionUndo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3592).

```rinzu
let actionUndo = -1;
```

## rinzu.macos.actions

Checked type: `fn()->UiActions`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L4728).

```rinzu
fn actions() -> UiActions
```

## rinzu.macos.activationAccessory

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1165).

```rinzu
let activationAccessory = 1;
```

## rinzu.macos.activationKeepCurrent

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1161).

```rinzu
let activationKeepCurrent = -1;
```

## rinzu.macos.activationRegular

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1163).

```rinzu
let activationRegular = 0;
```

## rinzu.macos.addressClamp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4033).

```rinzu
let addressClamp = 0;
```

## rinzu.macos.addressMirror

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4037).

```rinzu
let addressMirror = 2;
```

## rinzu.macos.addressRepeat

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4035).

```rinzu
let addressRepeat = 1;
```

## rinzu.macos.alertCritical

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1248).

```rinzu
let alertCritical = 2;
```

## rinzu.macos.alertInformational

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1246).

```rinzu
let alertInformational = 1;
```

## rinzu.macos.alertWarning

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1244).

```rinzu
let alertWarning = 0;
```

## rinzu.macos.application

Checked type: `async(String,Float,Float,fn(UiApplication)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3219).

```rinzu
async fn application(title: String, width: Float, height: Float, body: fn (UiApplication) -> Future<Unit>) -> Int
```

Own the OS loop, Window, jobs and GPU resources; body runs entirely in Rinzu.

## rinzu.macos.applicationWithOptions

Checked type: `async(String,ApplicationOptions,fn(UiApplication)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3147).

```rinzu
async fn applicationWithOptions(title: String, options: ApplicationOptions, body: fn (UiApplication) -> Future<Unit>)
    -> Int
```

Own an application session and apply its settings before running the body.

## rinzu.macos.applicationWithSignals

Checked type: `async(String,Float,Float,fn(UiApplication)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3224).

```rinzu
async fn applicationWithSignals(title: String, width: Float, height: Float, body: fn (UiApplication) -> Future<Unit>)
    -> Int
```

Opt into cooperative process signals, including rinzu dev cooperative restart.

## rinzu.macos.blendOpaque

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4039).

```rinzu
let blendOpaque = 0;
```

## rinzu.macos.blendPremultiplied

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4041).

```rinzu
let blendPremultiplied = 1;
```

## rinzu.macos.blendStraight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4043).

```rinzu
let blendStraight = 2;
```

## rinzu.macos.close

Checked type: `async(Session)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2485).

```rinzu
async fn close(session: Session) -> Int
```

Stop and await run, then join Source children before close. Drain GPU work first.

## rinzu.macos.closeOwnerSessions

Checked type: `async()->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2508).

```rinzu
async fn closeOwnerSessions() -> Int
```

Owner-scope recovery also closes native acquisitions not yet received by Source.

## rinzu.macos.column

Checked type: `fn(View,List<View>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3643).

```rinzu
fn column(parent: View, children: List<View>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.commandCopy

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3580).

```rinzu
let commandCopy = 2;
```

## rinzu.macos.commandCut

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3578).

```rinzu
let commandCut = 1;
```

## rinzu.macos.commandPaste

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3582).

```rinzu
let commandPaste = 3;
```

## rinzu.macos.commandQuit

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3590).

```rinzu
let commandQuit = 7;
```

## rinzu.macos.commandRedo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3588).

```rinzu
let commandRedo = 6;
```

## rinzu.macos.commandSelectAll

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3584).

```rinzu
let commandSelectAll = 4;
```

## rinzu.macos.commandUndo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3586).

```rinzu
let commandUndo = 5;
```

## rinzu.macos.compose2D

Checked type: `fn(Transform2D,Transform2D)->Transform2D`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L4093).

```rinzu
fn compose2D(first: Transform2D, next: Transform2D) -> Transform2D
```

Apply first, then next: next \* first.

## rinzu.macos.dataActivated

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5231).

```rinzu
let dataActivated = 2;
```

## rinzu.macos.dataCollapsed

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5235).

```rinzu
let dataCollapsed = 4;
```

## rinzu.macos.dataExpanded

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5233).

```rinzu
let dataExpanded = 3;
```

## rinzu.macos.dataSelected

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5229).

```rinzu
let dataSelected = 1;
```

## rinzu.macos.dataSorted

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5237).

```rinzu
let dataSorted = 5;
```

## rinzu.macos.decodeInputPacket

Checked type: `fn(String)->$rinzu_record_96aa4881bf57c1a9f8c8727785244b2e`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/input.rinzu#L87).

```rinzu
fn decodeInputPacket(text: String) -> InputPacket
```

## rinzu.macos.diagnostic

Checked type: `fn()->String`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2318).

```rinzu
fn diagnostic() -> String
```

Copy the latest Main-thread native diagnostic. Errors include this text.

## rinzu.macos.encodeInputSnapshot

Checked type: `fn($rinzu_record_7cbe9194647772263b53fcaa9ac66647)->ByteArray`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/input.rinzu#L188).

```rinzu
fn encodeInputSnapshot(value: InputSnapshot) -> ByteArray
```

## rinzu.macos.environmentDevices

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5301).

```rinzu
let environmentDevices = 16;
```

## rinzu.macos.environmentDisplays

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5297).

```rinzu
let environmentDisplays = 4;
```

## rinzu.macos.environmentFonts

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5293).

```rinzu
let environmentFonts = 1;
```

## rinzu.macos.environmentPreferences

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5295).

```rinzu
let environmentPreferences = 2;
```

## rinzu.macos.environmentWake

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5299).

```rinzu
let environmentWake = 8;
```

## rinzu.macos.eventAction

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2280).

```rinzu
let eventAction = 12;
```

## rinzu.macos.eventCloseRequested

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2257).

```rinzu
let eventCloseRequested = 2;
```

## rinzu.macos.eventData

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5227).

```rinzu
let eventData = 20;
```

## rinzu.macos.eventDraw

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2261).

```rinzu
let eventDraw = 4;
```

## rinzu.macos.eventEnvironment

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5286).

```rinzu
let eventEnvironment = 21;
```

Opt-in OS notifications and current accessibility display preferences.

## rinzu.macos.eventFocus

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2288).

```rinzu
let eventFocus = 16;
```

## rinzu.macos.eventInput

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5288).

```rinzu
let eventInput = 22;
```

## rinzu.macos.eventInputLimit

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3250).

```rinzu
let eventInputLimit = 19;
```

## rinzu.macos.eventKeyDown

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2265).

```rinzu
let eventKeyDown = 6;
```

## rinzu.macos.eventKeyUp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2267).

```rinzu
let eventKeyUp = 7;
```

## rinzu.macos.eventMouseDown

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2272).

```rinzu
let eventMouseDown = 8;
```

## rinzu.macos.eventMouseMoved

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2276).

```rinzu
let eventMouseMoved = 10;
```

## rinzu.macos.eventMouseUp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2274).

```rinzu
let eventMouseUp = 9;
```

## rinzu.macos.eventOverflow

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5291).

```rinzu
let eventOverflow = 23;
```

Session-wide loss notice. UiEvent.action counts the dropped events represented by this notice.

## rinzu.macos.eventQuitRequested

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2263).

```rinzu
let eventQuitRequested = 5;
```

## rinzu.macos.eventResized

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2259).

```rinzu
let eventResized = 3;
```

## rinzu.macos.eventScroll

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2286).

```rinzu
let eventScroll = 15;
```

## rinzu.macos.eventSelectionChanged

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2284).

```rinzu
let eventSelectionChanged = 14;
```

## rinzu.macos.eventStarted

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2255).

```rinzu
let eventStarted = 1;
```

## rinzu.macos.eventStopped

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2278).

```rinzu
let eventStopped = 11;
```

## rinzu.macos.eventTaskFinished

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2292).

```rinzu
let eventTaskFinished = 18;
```

## rinzu.macos.eventTextChanged

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2282).

```rinzu
let eventTextChanged = 13;
```

## rinzu.macos.eventWindowState

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2290).

```rinzu
let eventWindowState = 17;
```

## rinzu.macos.filterLinear

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4031).

```rinzu
let filterLinear = 1;
```

## rinzu.macos.filterNearest

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4029).

```rinzu
let filterNearest = 0;
```

## rinzu.macos.identity2D

Checked type: `fn()->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L4073).

```rinzu
fn identity2D() -> Transform2D
```

## rinzu.macos.keyRepeat

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2270).

```rinzu
let keyRepeat = 1;
```

UiEvent.flags bit for a repeated raw key event on a native view or surface.

## rinzu.macos.metalAvailable

Checked type: `native()->Bool`.

native-function · [source](../src/macos.rinzu#L1985).

```rinzu
fn metalAvailable() -> CBool symbol "rinzu_macos_metal_available";
```

## rinzu.macos.modifierCommand

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3576).

```rinzu
let modifierCommand = 1048576;
```

## rinzu.macos.modifierControl

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3572).

```rinzu
let modifierControl = 262144;
```

## rinzu.macos.modifierOption

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3574).

```rinzu
let modifierOption = 524288;
```

## rinzu.macos.modifierShift

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3570).

```rinzu
let modifierShift = 131072;
```

## rinzu.macos.nextEvent

Checked type: `async(Session)->UiEvent`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2386).

```rinzu
async fn nextEvent(session: Session) -> UiEvent
```

Wait for one owned event. A single reader may be active per Session.

## rinzu.macos.open

Checked type: `fn()->Session`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2330).

```rinzu
fn open() -> Session
```

Open one Main-owned application resource scope. Close explicitly.

## rinzu.macos.pixelAlpha8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4014).

```rinzu
let pixelAlpha8 = 4;
```

R8Unorm coverage, sampled as (a, a, a, a) for premultiplied composition.

## rinzu.macos.pixelBGRA8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4008).

```rinzu
let pixelBGRA8 = 2;
```

## rinzu.macos.pixelBGRA8Srgb

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4004).

```rinzu
let pixelBGRA8Srgb = 6;
```

## rinzu.macos.pixelR8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4011).

```rinzu
let pixelR8 = 3;
```

Single stored R8Unorm channel, sampled as (r, 0, 0, 1).

## rinzu.macos.pixelRGBA8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4006).

```rinzu
let pixelRGBA8 = 1;
```

## rinzu.macos.pixelRGBA8Srgb

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4002).

```rinzu
let pixelRGBA8Srgb = 5;
```

## rinzu.macos.preferenceDifferentiateWithoutColor

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5309).

```rinzu
let preferenceDifferentiateWithoutColor = 8;
```

## rinzu.macos.preferenceIncreaseContrast

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5307).

```rinzu
let preferenceIncreaseContrast = 4;
```

## rinzu.macos.preferenceReduceMotion

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5303).

```rinzu
let preferenceReduceMotion = 1;
```

## rinzu.macos.preferenceReduceTransparency

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5305).

```rinzu
let preferenceReduceTransparency = 2;
```

## rinzu.macos.readDocument

Checked type: `async(String)->String`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/document_files.rinzu#L8).

```rinzu
async fn readDocument(path: String) -> String
```

Read plain UTF8 with a 1 MiB bound; the enclosing Owner recovers unreceived opens.

## rinzu.macos.rotation2D

Checked type: `fn(Float)->Transform2D`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L4086).

```rinzu
fn rotation2D(radians: Float) -> Transform2D
```

Positive rotation is clockwise in the batch's top-left coordinate system.

## rinzu.macos.row

Checked type: `fn(View,List<View>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3647).

```rinzu
fn row(parent: View, children: List<View>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.run

Checked type: `async(Session,fn($rinzu_record_f7c713f12e29ebb74f67222ddd835128,Event)->Unit)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2370).

```rinzu
async fn run(session: Session, handler: fn (RunContext, Event) -> Unit) -> Int
```

Run NSApplication on Main. The handler is synchronous and valid only during run.

## rinzu.macos.runEvents

Checked type: `fn(Session)->Future<Int>`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2380).

```rinzu
fn runEvents(session: Session) -> Future<Int>
```

## rinzu.macos.saveDocument

Checked type: `async(String,String)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/document_files.rinzu#L34).

```rinzu
async fn saveDocument(path: String, text: String) -> Int
```

Unique sibling temporary file -> bounded writes -> fsync -> atomic rename -> close.
Cancellation before installation removes the temporary during close/Owner recovery.

## rinzu.macos.scale2D

Checked type: `fn(Float,Float)->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L4081).

```rinzu
fn scale2D(x: Float, y: Float) -> Transform2D
```

## rinzu.macos.scrollPrecise

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3863).

```rinzu
let scrollPrecise = 1;
```

## rinzu.macos.scrollViewport

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3865).

```rinzu
let scrollViewport = 2;
```

## rinzu.macos.statistics

Checked type: `fn()->Statistics`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2335).

```rinzu
fn statistics() -> Statistics
```

Measured live payloads and separately retained alias-check controls.

## rinzu.macos.stop

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2457).

```rinzu
fn stop(session: Session) -> Int
```

## rinzu.macos.textCenter

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4480).

```rinzu
let textCenter = 1;
```

## rinzu.macos.textComposing

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3846).

```rinzu
let textComposing = 1;
```

Text snapshots with this flag are provisional IME input, outside document history.

## rinzu.macos.textLeft

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4478).

```rinzu
let textLeft = 0;
```

## rinzu.macos.textRight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4482).

```rinzu
let textRight = 2;
```

## rinzu.macos.textureAlphaDefault

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4023).

```rinzu
let textureAlphaDefault = 0;
```

Keep the legacy Batch2D convention for textures with unspecified alpha representation.

## rinzu.macos.textureAlphaPremultiplied

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4025).

```rinzu
let textureAlphaPremultiplied = 1;
```

## rinzu.macos.textureAlphaStraight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4027).

```rinzu
let textureAlphaStraight = 2;
```

## rinzu.macos.textureRenderTarget

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4018).

```rinzu
let textureRenderTarget = 2;
```

## rinzu.macos.textureSampled

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4016).

```rinzu
let textureSampled = 1;
```

## rinzu.macos.textureStorage

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4020).

```rinzu
let textureStorage = 4;
```

## rinzu.macos.themeDark

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5243).

```rinzu
let themeDark = 2;
```

## rinzu.macos.themeLight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5241).

```rinzu
let themeLight = 1;
```

## rinzu.macos.themeSystem

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L5239).

```rinzu
let themeSystem = 0;
```

## rinzu.macos.translation2D

Checked type: `fn(Float,Float)->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L4077).

```rinzu
fn translation2D(x: Float, y: Float) -> Transform2D
```

## rinzu.macos.wait

Checked type: `async(Command)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2480).

```rinzu
async fn wait(command: Command) -> Int
```

Await and physically settle a submitted command. The handle becomes reusable.

## rinzu.macos.weightedColumn

Checked type: `fn(View,List<LayoutItem>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L4802).

```rinzu
fn weightedColumn(parent: View, items: List<LayoutItem>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.weightedRow

Checked type: `fn(View,List<LayoutItem>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L4798).

```rinzu
fn weightedRow(parent: View, items: List<LayoutItem>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.windowFullScreen

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3858).

```rinzu
let windowFullScreen = 32;
```

## rinzu.macos.windowKey

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3850).

```rinzu
let windowKey = 2;
```

## rinzu.macos.windowMain

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3852).

```rinzu
let windowMain = 4;
```

## rinzu.macos.windowMinimized

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3854).

```rinzu
let windowMinimized = 8;
```

## rinzu.macos.windowOccluded

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3861).

```rinzu
let windowOccluded = 64;
```

Window has no visible pixels according to AppKit, including occlusion by other windows.

## rinzu.macos.windowStyleBorderless

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1151).

```rinzu
let windowStyleBorderless = 0;
```

## rinzu.macos.windowStyleClosable

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1155).

```rinzu
let windowStyleClosable = 2;
```

## rinzu.macos.windowStyleMiniaturizable

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1157).

```rinzu
let windowStyleMiniaturizable = 4;
```

## rinzu.macos.windowStyleResizable

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1159).

```rinzu
let windowStyleResizable = 8;
```

## rinzu.macos.windowStyleTitled

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1153).

```rinzu
let windowStyleTitled = 1;
```

## rinzu.macos.windowVisible

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3848).

```rinzu
let windowVisible = 1;
```

## rinzu.macos.windowZoomed

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3856).

```rinzu
let windowZoomed = 16;
```

## rinzu.macos.withWindow

Checked type: `async(Session,String,Float,Float,fn(UiScope)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3052).

```rinzu
async fn withWindow(session: Session, title: String, width: Float, height: Float, body: fn (UiScope) -> Future<Unit>)
    -> Int
```

A Window scope within the running Application. The application has one event reader.

## rinzu.macos.withWindowOptions

Checked type: `async(Session,String,WindowOptions,fn(UiScope)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3057).

```rinzu
async fn withWindowOptions(session: Session, title: String, options: WindowOptions, body: fn (UiScope) -> Future<Unit>)
    -> Int
```
