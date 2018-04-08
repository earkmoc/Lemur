var canvas=document.querySelector('canvas');
var context=canvas.getContext('2d');
var particles=[];

var png=document.images[0];
png.onload=draw();

function draw()
{
	canvas.width=png.width*4;
	canvas.height=png.height*4;
	context.drawImage(png, 0, 0);
	
	var data=context.getImageData(0,0,png.width,png.height);
	for(var y=0; y<data.width; ++y)
	{
		for(var x=0; x<data.height; ++x)
		{
			var p=(x+y*data.width)*4;
//			alert(data.data[p+0]+', '+data.data[p+1]+', '+data.data[p+2]+', '+data.data[p+3]);	//235,0,9,227
			if(data.data[p+3]>0)
			{
				var particle={
					 x0:x+png.height/2
					,y0:y+png.width/4
					,x1:png.width-png.width/3
					,y1:png.height-png.height/3
					,speed: Math.random()*10
					,color: 'rgba('+data.data[p+0]+','+data.data[p+1]+','+data.data[p+2]+','+data.data[p+3]/227+')'
				}
				TweenMax.to(particle, particle.speed, {
					x1:particle.x0,
					y1:particle.y0,
					delay: x/5,
					ease: Elastic.easeOut
				});
				particles.push(particle);
			}
		}
	}
	render();
}

function render()
{
	requestAnimationFrame(render);
	context.clearRect(0,0,canvas.width,canvas.height);
	for(var i=0;i<particles.length; ++i)
	{
		context.fillStyle=particles[i].color;
		context.strokeStyle = particles[i].color;
//		context.strokeStyle = 'white';
//		context.strokeStyle = 'black';
		context.fillRect(particles[i].x1*2,particles[i].y1*2,3,3);
//		context.beginPath();
//		context.arc(particles[i].x1*2,particles[i].y1*2,2,0,2*Math.PI);
//		context.fill();
//		context.stroke();
	}
}
