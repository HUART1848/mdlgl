import numpy as np

from pathlib import Path

import moderngl_window as mglw

class App(mglw.WindowConfig):
    title = "mdlgl"
    window_size = (1000, 1000)
    resource_dir = (Path(__file__).parent / "shaders").resolve()
    aspect_ratio = 1
    resizable = False

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.quad = mglw.geometry.quad_fs()
        self.prog = self.load_program(
            vertex_shader="vertex.glsl",
            fragment_shader="fragment.glsl"
        )

        self.set_uniform("resolution", self.window_size)

    def set_uniform(self, name, value):
        try:
            self.prog[name] = value
        except KeyError:
            print(f"No {name}")
        
    def render(self, time, frametime):
        self.ctx.clear()
        self.set_uniform("time", time)
        self.quad.render(self.prog)

def main():
    App.run()

if __name__ == "__main__":
    main()
