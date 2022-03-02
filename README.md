# miniCPU

*************************
超标量结构思考

*************************
取指阶段

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3029.JPG" width="600px"  />

*************************
重命名阶段（考虑读优先SRAM）

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3030.JPG" width="600px"  />

*************************
发射阶段（考虑ROB,发射队列的分配，考虑LS单独，考虑预测恢复用表）

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3032.JPG" width="600px"  />

*************************
执行阶段，考虑LS和分支预测的恢复

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3033.JPG" width="600px"  />

*************************
提交阶段，考虑异常的恢复

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3034.JPG" width="600px"  />

*************************
互联基础，细节略去

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3036.JPG" width="600px"  />

*************************
缓存基础，不考虑多级缓存

<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/IMG_3038.JPG" width="600px"  />

*************************


OS思路
<img src="https://raw.githubusercontent.com/mashirol/miniCPU/master/imgIMG_3037.JPG" width="600px"  />

