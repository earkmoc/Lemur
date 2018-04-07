//console.log('r/place');

var canvas=document.querySelector('canvas');
var X=window.innerWidth;
var Y=window.innerHeight;
var stop=false;

canvas.width=X;
canvas.height=Y;

var context=canvas.getContext('2d');

function Okno(x, y, dx, dy, fillStyle)
{
	this.draw=function()
	{
		context.fillStyle=fillStyle;
		context.beginPath();
		context.fillRect(x,y,dx,dy);
		context.stroke();
	};
}

function Part(a,x,y)
{
	this.a=a;
	this.x=x;
	this.y=y;
	
	this.draw=function(a)
	{
		context.rotate(this.a*a);
		context.lineTo(this.x,this.y);
	}
}

function Patyk(x, y, len, angleMin, angleMax, partArray)
{
	this.x=x;
	this.y=y;
	this.len=len;
	this.angleCur=angleMin*Math.PI/180;
	this.angleMin=angleMin*Math.PI/180;
	this.angleMax=angleMax*Math.PI/180;
	this.angleStep=(this.angleMax-this.angleMin)/100;
	this.dir=-1;

	this.draw=function()
	{
//		context.fillStyle="blue";
//		context.beginPath();
//		context.moveTo(this.x,this.y);
//		context.lineTo(this.x+this.len*Math.cos(this.angleCur),this.y+this.len*Math.sin(this.angleCur));
//		context.stroke();

		context.save(); // saves the coordinate system
		context.translate(this.x,this.y); // now the position (0,0) is found at (this.x,this.y)
		context.rotate(this.angleCur); // rotate around the start point of your line
		context.moveTo(0,0) // this will actually be (250,50) in relation to the upper left corner
		for(var i=0; i<partArray.length; ++i) {partArray[i].draw(this.angleCur);}
		context.stroke();
		context.restore(); // restores the coordinate system back to (0,0)
	};

	this.update=function(d)
	{
		this.angleCur+=this.dir*d*this.angleStep;
		if(this.angleCur<-this.angleMax) {this.dir=-this.dir;this.angleCur=-this.angleMax;}//stop=ttrue;}
		if(this.angleCur>-this.angleMin) {this.dir=-this.dir;this.angleCur=-this.angleMin;}
		this.draw();
	};
}

context.clearRect(0,0,X,Y);

//Chevrolet
//var okno=new Okno(50,50,1350,800,"rgba(0, 0, 255, 0.3)");okno.draw();
//var patykArray=[];
//patykArray.push(new Patyk(50+1350-800,50+800,800,1,115));
//patykArray.push(new Patyk(50,50+800,800,1,89));

//Fela: szyba: 140/104

var patykArray=[];
//wycieraczki: oś=73(50, 3), oś=125 (50=105-55)

var partArray=[];
partArray.push(new Part(0,200,0));
partArray.push(new Part(-0.025,270,5));
partArray.push(new Part(-0.025,300,-20));
partArray.push(new Part(+0.19,120,-30));
partArray.push(new Part(-0.22,570,0));
patykArray.push(new Patyk(420,854,550,1,125,partArray));	//lewa

var partArray=[];
partArray.push(new Part(0,200,0));
partArray.push(new Part(0,270,5));
partArray.push(new Part(0,300,-20));
partArray.push(new Part(0,100,-30));
partArray.push(new Part(0,550,0));
patykArray.push(new Patyk(978,854,550,1,115,partArray));	//prawa

//Elipsa
//((x*x))/(a*a))+((y*y)/(b*b))=1

function drawEllipse(centerX, centerY, width, height) {
	
  context.beginPath();
  
  context.moveTo(centerX, centerY - height/2); // A1
  
  context.bezierCurveTo(
    centerX + width/2, centerY - height/2, // C1
    centerX + width/2, centerY + height/2, // C2
    centerX, centerY + height/2); // A2

  context.bezierCurveTo(
    centerX - width/2, centerY + height/2, // C3
    centerX - width/2, centerY - height/2, // C4
    centerX, centerY - height/2); // A1
 
//  context.fillStyle = "red";
//  context.fill();
//  context.closePath();
  context.stroke();
}

//drawEllipse(300,854, 1984,1080);
//drawEllipse(978,854, 1984,1080);

function Mouse()
{
	this.x=undefined;
	this.y=undefined;
	this.a=undefined;
	this.b=undefined;
	this.state=1;
	this.updatePos=function(event)
	{
		this.x=event.x;
		this.y=event.y;
	}
	this.updateSize=function(event)
	{
		this.a=event.x*2;
		this.b=event.y*2;
	}
	this.update=function(event)
	{
		if(mouse.state==1)
		{
			mouse.updatePos(event);
		}
		else
		{
			mouse.updateSize(event);
		}
	}
}

var mouse=new Mouse();
window.addEventListener('mousemove',function(event) {
	mouse.update(event);
//	console.log(mouse);
});

window.addEventListener('click',function(event) {
	mouse.state=(1-mouse.state);
	console.log(mouse);
});

function animate()
{
	requestAnimationFrame(animate);
	if(stop) {return;}
	context.clearRect(0,0,X,Y);
	drawEllipse(mouse.x,mouse.y,mouse.a,mouse.b);
	for(var i=0; i<patykArray.length; ++i) {patykArray[i].update(1);}
}

animate();
