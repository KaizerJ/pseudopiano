import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

//Notas musicales en notación anglosajona
String [] notas={"A3", "B3", "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};

// Clase que describe la interfaz del instrumento, idéntica al ejemplo
//Modifcar para nuevos instrumentos
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // Oscilador sinusoidal con envolvente
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // Secuenciador de notas
  void noteOn( float duration )
  {
    // Amplitud de la envolvente
    ampEnv.activate( duration, 0.5f, 0 );
    // asocia el oscilador a la salida
    wave.patch( out );
  }
  
  // Final de la nota
  void noteOff()
  {
    wave.unpatch( out );
  }
}

int[] colors = {color(0,0,0), color(135,206,250), color(106,90,205), color(138,43,226), color(250,128,114), color(255,69,0), color(220,20,60), color(0,250,154), color(152,251,152), color(255,182,193)};

int strip_size = 50+15;
int padding = 15;
int yBaseline = 360;

ArrayList<Shape> shapes = new ArrayList();

class Shape {
  private int strip;
  private int yPos;
  
  Shape(int strip){
    this.strip = strip;
    this.yPos = 0;
  }
  
  void drawShape(){
    stroke(colors[strip]);
    fill(colors[strip]);
    square(strip*strip_size+padding + 15 , yBaseline - yPos - 20, 20);
  }
  
  void moveUp(){
    this.yPos += 1;
  }
  
  boolean isVisible(){
    return yPos < yBaseline + 20;
  }
}

void setup()
{
  size(665, 470);
  
  minim = new Minim(this);
  
  // Línea de salida
  out = minim.getLineOut();
}

void draw() {
  background(192);
  
  
  //Dibujamos las celdas/teclas
  for (int i=0;i<10;i++){
    stroke(colors[i]);
    fill(colors[i]);
    
    // strip line
    rect(i*strip_size+padding + 24 , 5, 2, yBaseline - 10);
    
    // tile
    rect(i*strip_size+padding,360,50,100);
  }
  
  ArrayList<Shape> removables = new ArrayList();
  // Dibujamos y bovemos las figuras
  for(Shape s: shapes){
    s.drawShape();
    s.moveUp();
    if( !s.isVisible() ) removables.add(s);
  }
  
  // Quitamos las figuras innecesarias
  shapes.removeAll(removables);
   
}

void keyPressed(){
  
  int tecla = -1;
  if( key == 'q' || key == 'Q' ){
    tecla = 0;
  } if( key == 'w' || key == 'W' ){
    tecla = 1;
  } if( key == 'e' || key == 'E' ){
    tecla = 2;
  } if( key == 'r' || key == 'R' ){
    tecla = 3;
  } if( key == 't' || key == 'T' ){
    tecla = 4;
  } if( key == 'y' || key == 'Y' ){
    tecla = 5;
  } if( key == 'u' || key == 'U' ){
    tecla = 6;
  } if( key == 'i' || key == 'I' ){
    tecla = 7;
  } if( key == 'o' || key == 'O' ){
    tecla = 8;
  } if( key == 'p' || key == 'P' ){
    tecla = 9;
  }
  
  if( tecla >= 0){
    //Primeros dos parámetros, tiempo y duración
    out.playNote( 0.0, 0.9, new SineInstrument( Frequency.ofPitch( notas[tecla] ).asHz() ) );
    shapes.add(new Shape(tecla));
  }
}

void mousePressed() {
  //Nota en función del valor de mouseX
  int tecla=(int)((mouseX-padding)/strip_size);
  
  //Primeros dos parámetros, tiempo y duración
  out.playNote( 0.0, 0.9, new SineInstrument( Frequency.ofPitch( notas[tecla] ).asHz() ) );
  shapes.add(new Shape(tecla));
}
