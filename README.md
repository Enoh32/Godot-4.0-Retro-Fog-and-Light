# Godot-4.0-Retro-Fog-and-Light
Small shader and script example for custom per-vertex Fog and Lighting

  The included shader is a simple world-space projected UV "terrain" shader, not very sophisticated.
It's primary purpose to to serve as an example and starting point.
The fog is calculated per-vertex using screen z-depth of the vertex much like the N64 and anything else doing per-vertex Fog at the time.

  The Shader Global must be created first in project settings, then it can be used in the shader (name must match perfectly).
They can also be modified in real-time using the "RenderingServer.global_shader_parameter_set()" function in a script.
A sort of World or otherwise Global script would work best for this.

  For example: RenderingServer.global_shader_parameter_set("EnvFogColor", ambient_color.srgb_to_linear())
This sets the EnvFogColor global to the scene ambient_color and is converted to linear (required for accurate color).

Hopefully this explanation suffices for now. Enjoy making Retro-Graphics in Godot 4.0 :)
Once Godot 4.X supports actual Vertex Shading, you can just use the Fog part instead of calculating lighting yourself.
