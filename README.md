# Fireboy &amp; Water Girl In the Forest Temple on FPGA 🕹️🌲🔥❄️
This project is a course project for ***UIUC's ECE385 Digital Systems Laboratory***. It aims to recreate the classic game Fireboy &amp; Water Girl In the Forest Temple an FPGA board, based on the early course materials. I have designed the animation module, character interaction module, and control module individually, and also integrated the sound module with assistance. Here is the video demo [link](https://www.bilibili.com/video/BV1Sb4y1Y7nL?p=1&share_medium=android&share_plat=android&share_session_id=ae0475a6-4244-4f3e-b69b-f47486d13408&share_source=WEIXIN_MONMENT&share_tag=s_i&timestamp=1641054250&unique_k=S9lwpVD). Our project has won one of the Best Design Awards in the course! 🏆🎉
![image](./ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_originals/background_big.png)

## Table of Contents 📚
* **<a href="#ack"> <u>Acknowledgments</u>**</a>
* **<a href="#req"> <u>Requirements</u>**</a>
* **<a href="#set"> <u>Setup</u>**</a>
* **<a href="#mod"> <u>Module Description</u>**</a>
* **<a href="#lic"> <u>License</u>**</a>
* **<a href="#cite"> <u>Citation</u>**</a>

## <a id="ack">Acknowledgments</a> 🙌
I would like to express my gratitude to my teammate [Song Yifei](https://github.com/yifeis7) and our instructor Professor [Li Chushan](https://person.zju.edu.cn/lichushan) for their guidance and support throughout the development of this project. 


## <a id="req">Requirements</a> ⚙️
To run this project, you will need the following:
* FPGA DE2-115 Board
* A standardized keyboard
* Quartus 18.1 software

## <a id="set">Setup</a> 🚀
1. Clone this repository:
```
git clone https://github.com/Hank0626/FPGA-Game-Desigan.git
```

2. Open the project in Quartus 18.1:
```
cd FPGA-Game-Desigan
```
3. Connect the FPGA DE2-115 Board to your computer.

4. Connect a standardized keyboard to the FPGA DE2-115 Board.

5. Compile the project and program the FPGA DE2-115 Board using Quartus 18.1.

6. Once the FPGA DE2-115 Board is programmed, the game will start automatically. Enjoy!


## <a id="vid">Module Description</a>
Here is our module architecture. 
```
{FPGA-GAME-DESIGN}
    └─────ECE385-HelperTools-master
    └─────src
            ├───hpi_io_intf.sv
            ├───VGA_controller.sv
            ├───lab8.sv
            ├───background.sv
            ├───map1.sv
            ├───button.sv
            ├───button1.sv
            ├───button_yellow.sv
            ├───girl_word.sv
            ├───boy_word.sv
            ├───collision.sv
            ├───collision_board.sv
            ├───box_collide.sv
            ├───collision_box.sv
            ├───red_diamond.sv
            ├───blue_diamond.sv
            ├───is_red_diamond eat.sv
            ├───is_blue_diamond eat.sv
            ├───girl_motion.sv
            ├───boy_motion.sv
            ├───board_motion.sv
            ├───board_purple_motion.sv
            ├───box_motion.sv
            ├───win_girl.sv
            ├───win_boy.sv
            ├───dead_girl.sv
            ├───dead_boy.sv
            ├───button_push.sv
            ├───button_puple_push1.sv
            ├───button_puple_push2.sv
            ├───designer.sv
            ├───color_mapper.sv
            ├───game_logic.sv
            ├───HexDriver.sv
            ├───select.sv
            ├───keycode_select.sv
            ├───audio.sv
            ├───music.sv
```

## <a id="lic">License</a>
All details can be found in the [license](./LICENSE) files.

## <a id="cite">Citation</a>
Part of our code is base on this Part of our code is based on [ECE385-HelperTools-master](https://github.com/atrifex/ECE385-HelperTools). We would like to thank them for their excellent work.
