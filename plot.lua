-- easing/plot.

include('lib/easing')
include('lib/interpolation')


-- ------------------------------------------------------------------------
-- conf

local viewport = { width = 64, height = 64, frame = 0 }

-- local ease_fn = easeinquad
-- local ease_fn = easeoutquad
local ease_fn = easeinbounce


-- ------------------------------------------------------------------------
-- state

curr_time = .0


-- ------------------------------------------------------------------------
-- init

function init()
  screen.aa(0)
  screen.line_width(1)
end

local fps = 30
redraw_clock = clock.run(
  function()
    local step_s = 1 / fps
    while true do
      clock.sleep(step_s)
      curr_time = curr_time + step_s
      redraw()
    end
end)

function cleanup()
  clock.cancel(redraw_clock)
end


-- ------------------------------------------------------------------------
-- loop

function t()
  return curr_time
end

function redraw()
  screen.clear()

  draw_easing_fn()

  screen.update()
end


function line (x0, y0, x1, y1, l)
  screen.level(l)
  screen.move(x0, y0)
  screen.line(x1, y1)
  screen.stroke()
end

function circfill(x, y, r, l)
  screen.level(l)
  screen.move(x + r, y)
  screen.circle(x, y, r)
  screen.fill()
end


function draw_easing_fn()

  -- frame
  screen.rect(1, 1, viewport.width-1, viewport.height-1)
  screen.stroke()

  local w = viewport.width - 2
  local h = viewport.height - 2

  local xlow = 0
  local xhigh = 1

  local ylow = 0
  local yhigh = 1

  local lval=0
  for t = 0, w do
    local val=(ease_fn(t/w*(xhigh-xlow))-ylow)/(yhigh-ylow)*h

    screen.pixel(t, h - val)
    -- rectfill(t,-lval,t,-val,funccol)
    lval=val
  end

  -- animation: time
  local t = util.clamp(t()/2%1.4-.2, 0, 1)
  line(8,38,lerp(8,120,t),38,4)
  line(120,38,lerp(8,120,t),38,15)
  screen.pixel(lerp(8,120,t),38)

  circfill(
    lerp(8,120,ease_fn(t)),
    48,3,8)

end
