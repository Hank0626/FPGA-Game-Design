from PIL import Image
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
filename = input("What's the image name? ")
new_w, new_h = map(int, input("What's the new height x width? Like 28 28. ").split(' '))
# palette_hex = ['0xf80504',
#                '0x69ddfb',
#                '0xf9de7a',
#                '0x796e36',
#                '0x444123',
#                '0x807029',
#                '0x2f2c1a'
#                '0x000000']
# palette_hex = ['0xffffff',
#                '0x69ddfb',
#                '0x000000']
palette_hex = ['0xf80504',
               '0x69ddfb',
               '0x59e90c',
               '0x5f582b',
               '0x716734',
               '0x2d2e0c',
               '0x202100',
               '0x000000',
               '0xac0404', # red for dead
               '0x4face5', # blue for dead
               '0x69a42a', # green for dead
               '0x776633'] # brown for win
# palette_hex = ['0x9a12a2', '0x000000', '0xdcdcd9']
# palette_hex = ['0xffffff','0x9a12a2', '0xefbe41']
# palette_hex = ['0xffffff', '0xceb244']
# palette_hex = ['0xffffff', '0xb5b72a', '0xefbe41']
# palette_hex = ['0xffffff', '0xf80504', '0x000000']
# palette_hex = ['0xffffff',
#                '0xf80504',
#                '0xff4c4a',
#                '0xfe9597',
#                '0xba0102']
# palette_hex = ['0x00000', '0xf80504', '0x69ddfb']
#palette_hex = ['0x00000', '0xdd8ad2']
# palette_hex = ['0xffffff', '0xd8ca72']
# palette_hex = ['0xffffff', '0xc2ae4d']

palette_rgb = [hex_to_rgb(color) for color in palette_hex]

pixel_tree = KDTree(palette_rgb)
im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
im = im.convert("RGBA")
im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
pix = im.load()
pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
pix_freqs_sorted.reverse()
print(pix)
outImg = Image.new('RGB', im.size, color='white')
outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        print(pixel)
        if(pixel[3] < 200):
            outImg.putpixel((x,y), palette_rgb[0])
            outFile.write("%x\n" % (0))
            print(i)
        else:
            index = pixel_tree.query(pixel[:3])[1]
            outImg.putpixel((x,y), palette_rgb[index])
            outFile.write("%x\n" % (index))
        i += 1
outFile.close()
outImg.save("./sprite_converted/" + filename + ".png")
