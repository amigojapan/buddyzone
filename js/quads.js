function clone(obj) {
    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        var copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        var i = 0;
        var len = obj.length;
        for (i = 0; i < len; ++i) {
            copy[i] = clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

Quadrant = new Object();
Quadrant.init2=function(top,left,quadsize){
	this.ships= new Array();
	this.top= top;
	this.left=left;
	this.quadsize=quadsize;
}
Quadrant.get_top=function(){
	return this.top;
}
Quadrant.get_left=function(){
	return this.left;
}
Quadrant.get_bottom=function(){
	return this.top+this.quadsize;
}
Quadrant.get_right=function(){
	return this.left+this.quadsize;
}
Board = new Object();
Board.init2=function(quadsize,width,height) {
	this.quadsize=quadsize;
	columns=Math.ceil(width/quadsize);
	rows=Math.ceil(height/quadsize);
	this.quadlist= new Array();
	for(c1=0;c1<rows;c1++) {
		onerow= new Array();
		for(c2=0;c2<columns;c2++){
			quadobj=clone(Quadrant);//this should inherit from Quadrant
			quadobj.init2(c2*quadsize,c1*quadsize,quadsize);
			onerow.push(quadobj);
		}
		this.quadlist.push(onerow);
	}
}

function get_quadnumber(xoryval,quadsize) {
	return Math.floor(xoryval/quadsize);
}
function remove_element_from_array(array,element) {
    var index = array.indexOf(element);
    array.splice(index,1);	
}
ship_class = new Object();
ship_class.init2=function(x,y,board,shipname){
	this.x=x;
	this.y=y;
	this.shipname=shipname;
	this.quadsize=board.quadsize;
	
	this.newrow=0;
	this.newcolumn=0;
	this.counter=0;

	
	//place ship in quadrant
	this.quadrownumber=get_quadnumber(x,this.quadsize);
	this.quadcolumnnumber=get_quadnumber(y,this.quadsize);
	//board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships.push(this);
	this.x=x;
	this.y=y;
	//this.setdirection(angle,speed);
	this.quadsize=board.quadsize;
	
	this.newrow=0;
	this.newcolumn=0;
	this.counter=0;

	
	//place ship in quadrant
	this.move_ship=function(new_x,new_y) {
		this.quadrownumber=get_quadnumber(this.x,this.quadsize);
		this.quadcolumnnumber=get_quadnumber(this.y,this.quadsize);
		var ship=this
		//delete ship from quadrant if already there(maybe this can be optimized)
		for(var ship2_counter in board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships) {
			var quad_ship =board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships[ship2_counter];
			if(quad_ship==ship) {
				//board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships.splice(quad_ship,1);
				remove_element_from_array(board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships,quad_ship)
			}
		}
		this.quadrownumber=get_quadnumber(new_x,this.quadsize);
		this.quadcolumnnumber=get_quadnumber(new_y,this.quadsize);		
		board.quadlist[this.quadrownumber][this.quadcolumnnumber].ships.push(ship);
	}
	this.move_ship(x,y);
}
function scan_quardan_for_other_ships(ship2) {
	var FOUND=false;
	var other_shipX=undefined;
	var other_shipY=undefined;
	var othership=undefined;
	for(ship in ship_array) {
		if(ship_array[ship]==ship2) continue;//skip currect ship
		if(get_quadnumber(ship2.x,board.quadsize)==get_quadnumber(ship_array[ship].x,board.quadsize) && get_quadnumber(ship2.y,board.quadsize)==get_quadnumber(ship_array[ship].y,board.quadsize)) {//same quadrant
			//if(ship_array[ship].cloaked==true) break;//skip cloaked ships
			FOUND=true;
			other_shipX=ship_array[ship].x;
			other_shipX=ship_array[ship].y; 
			othership=ship_array[ship];
			break;
		}
	}
	
	if(FOUND) {
		 //same quadrant
		 console.log("same quadrant");
	} else {
		console.log("different quadrant");
	}
}
function print_ships_quadrant(row,columb) {
	for(var ship_number in board.quadlist[row][columb].ships) {
			console.log("ship in quad row:"+row+"columb"+columb+"shipname:"+board.quadlist[row][columb].ships[ship_number].shipname);
	}
}

function print_ships_quadrant_and_adjacent_quadrants(row,columb) {
	print_ships_quadrant(row,columb)
	//top
	if(!(row-1<0)) {
		print_ships_quadrant(row-1,columb)
	}
	//bottom
	if(!(row+1>board.height)) {
		print_ships_quadrant(row+1,columb)
	}
	//left
	if(!(columb-1<0)) {
		print_ships_quadrant(row,columb-1)
	}
	//right
	if(!(columb+1>board.height)) {
		print_ships_quadrant(row,columb+1)
	}
	//topleft
	if(!(row-1<0)&&!(columb-1<0)) {
		print_ships_quadrant(row-1,columb-1)
	}
	//topright
	if(!(row-1<0)&&!(columb+1>board.height)) {
		print_ships_quadrant(row-1,columb+1)
	}
	//bottomleft
	if(!(row+1>board.height)&&!(columb-1<0)) {
		print_ships_quadrant(row+1,columb-1)
	}
	//bottomright
	if(!(row+1>board.height)&&!(columb+1>board.height)) {
		print_ships_quadrant(row+1,columb+1)
	}
}


function destroy_other_ship() {
	for(ship in currentquad.ships) {
		if(currentquad.ships[ship]!=this) {
			for(bship in ship_array) {
				if(ship_array[bship]==currentquad.ships[ship]) ship_array.splice(bship,1);
			}
			currentquad.ships.splice(ship,1);//remove this ship , if it doesnt work try substacting 1 from ship or change ship2 to ship
			break;
		}
	}
}
/*
function draw_quadrants() {
    //draw quadrants
    mainContext.strokeStyle="blue";
	quadsize=board.quadsize;
	mainContext.beginPath();
	for(x=0;x<surf1.width;x+=quadsize){
		mainContext.moveTo(x,0);
		mainContext.lineTo(x,surf1.height);
		mainContext.stroke();
	}
	for(y=0;y<surf1.height;y+=quadsize){
		mainContext.moveTo(0,y);
		mainContext.lineTo(surf1.width,y);
		mainContext.stroke();
	}
}
*/
function randint(minimum,maximum) {
	return Math.floor(Math.random()*(maximum-minimum))+minimum;
}
var width=1000;
var height=1000;
board=clone(Board);
board.init2(100,width,height);
ship_array= new Array();//ship array

/*
for(var count=0;count<10;count++) {
	ball=clone(ship_class);
	ball.init2(randint(0,width),randint(0,height),randint(0,360),randint(0,100),board);
	ship_array.push(ball);
}
*/
ship1=clone(ship_class);
ship1.init2(50,50,board,"nautilus");
ship_array.push(ship1);
ship2=clone(ship_class);
ship2.init2(60,60,board,"enterprise");
ship_array.push(ship2);
ship3=clone(ship_class);
ship3.init2(250,250,board,"voyager");
ship_array.push(ship3);
//scan_quardan(ship3);
ship2.move_ship(700,700);

console.log("ships in 1,1 and adjacent");
print_ships_quadrant_and_adjacent_quadrants(1,1);
console.log("ships in 7,7");
print_ships_quadrant(7,7);
