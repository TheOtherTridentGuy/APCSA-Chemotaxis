pixel[] pixels;
int height = 200;
int width = 200;
int[][][] biasimage = {
{{0,0,0}, {255, 255, 255}},
{{255, 255, 255}, {0,0,0}}
};
void setup()   
 { 
   // size is hardcoded because thats the only way it works apparently
   // width, height
   size(200, 200); 
   pixels = new pixel[1000];
   for(int i=0; i<pixels.length; i++){
     pixels[i] = new pixel(rand(0, width), rand(0, height), new int[] {rand(0,256), rand(0,256), rand(0,256)});
   }
 }
 int rand(int a, int b){
   return (int)(Math.random()*b)+a;
 }
 void draw()   
 {    
   background(0,0,0);
   for(pixel px: pixels){
     px.move();
     px.show();
   }   
 }
 void mousePressed(){
   for(pixel px: pixels){
     px.setbias(biasimage);
   }
 }
 class pixel    
 {   
   int d = 10;
   int x;
   int y;
   int[] rgb;
   boolean hasbias = false;
   int biasareax;
   int biasareay;
   int biasx;
   int biasy;
   pixel(int x, int y, int[] rgb){
     this.x = x;
     this.y = y;
     this.rgb = rgb;
   }
   void move(){
     if(hasbias){
       // do x
       if(this.x < (this.biasx*this.biasareax)){
         this.x += rand(0,2);
       }else if(this.x > ((this.biasx*this.biasareax)+this.biasareax)){
         this.x -= rand(0,2);
       }else{
         this.x += rand(0,2)==0?-1:1;
       }
       // do y
       if(this.y < (this.biasy*this.biasareay)){
         this.y += rand(0,2);
       }else if(this.y > ((this.biasy*this.biasareay)+this.biasareay)){
         this.x -= rand(0,2);
       }else{  
         this.y += rand(0,2)==0?-1:1;
       }
     }else{
       this.x += rand(0,2)==0?-1:1;
       this.y += rand(0,2)==0?-1:1;
     }
   }
   void setbias(int[][][] image){
     int colortune = 5;
     int bestx = 0;
     int besty = 0;
     int bestscore = 1000000;
     this.biasareax = width/image[0].length;
     this.biasareay = height/image.length;
     for(int y=0; y<image.length; y++){
       for(int x=0; x<image[0].length; x++){
         int xydist = (int)Math.sqrt(Math.pow(this.x-(x+this.biasareax), 2)+Math.pow(this.y-(y+this.biasareay), 2));
         int rgbdist = (int)Math.sqrt(Math.pow(this.rgb[0]-image[x][y][0], 2)+Math.pow(this.rgb[1]-image[x][y][1], 2)+Math.pow(this.rgb[2]-image[x][y][2], 2));
         int score = xydist+(rgbdist*colortune);
         if(score < bestscore){
           bestx = x;
           besty = y;
           bestscore = score;
         }
       }
     }
     this.biasx = bestx;
     this.biasy = besty;
     this.hasbias = true;
   }
   void show(){
     noStroke();
     fill(rgb[0], rgb[1], rgb[2]);
     ellipse(x, y, d, d);
   }
  }    
