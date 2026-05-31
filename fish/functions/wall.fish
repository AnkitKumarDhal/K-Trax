function wall
    set img (realpath $argv[1])
    set duration 1.5

    awww img $img --transition-type any --transition-duration $duration --transition-fps 120
    sleep $duration

    # pywal extracts first, its palette becomes matugen's source
    wal -i $img -n

    # pick the most chromatic accent from pywal's palette
    set source_color (python3 -c "
import json, colorsys
with open('/home/$USER/.cache/wal/colors.json') as f:
    data = json.load(f)
colors = [data['colors'][f'color{i}'] for i in range(1, 7)]
def chroma(h):
    r,g,b = int(h[1:3],16)/255, int(h[3:5],16)/255, int(h[5:7],16)/255
    return max(r,g,b) - min(r,g,b)
print(max(colors, key=chroma))
")

    echo "Source color from pywal: $source_color"
    matugen color hex $source_color
end
