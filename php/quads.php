<?php
	class Quadrant {
		var $ships;
		var $top;
		var $left;
		var $quadsize;
		function init2($top,$left,$quadsize){
			$this->ships= array();
			$this->top = $top;
			$this->left = $left;
			$this->quadsize=$quadsize;
		}
		function get_top(){
			return $this->top;
		}
		function get_left(){
			return $this->left;
		}
		function get_bottom(){
			return $this->top+$this->quadsize;
		}
		function get_right(){
			return $this->left+$this->quadsize;
		}
	}


	class Board {
		var $quadsize;
		var $rows;
		var $columns;
		var $quadlist;
		var $width;
		var $height;
		function init2($quadsize,$width,$height) {
			$this->width=$width;
			$this->height=$height;
			$this->quadsize=$quadsize;
			$this->columns=ceil($width/$quadsize);
			$this->rows=ceil($height/$quadsize);
			$this->quadlist= array();
			for($c1=0;$c1<$this->rows;$c1++) {
				$onerow= array();
				for($c2=0;$c2<$this->columns;$c2++){
					$quadobj= new Quadrant();
					$quadobj->init2($c2*$this->quadsize,$c1*$this->quadsize,$this->quadsize);
					array_push ($onerow, $quadobj);
				}
				array_push ($this->quadlist , $onerow);
			}
		}
	}
	function get_quadnumber($xoryval,$quadsize) {
		return floor($xoryval/$quadsize);
	}
	function remove_element_from_array(&$array,$element) {
		//var index = array.indexOf(element);
		//array.splice(index,1);	
		$key=array_search($element->shipname,$array);
		//echo("\nhere:".$element->shipname."\n");
		unset($array[$key+1]);//seems there was an off by one error, so I just added one
	}

	class Ship_class {
		var $x;
		var $y;
		var $shipname;
		var $quadsize;
		var $newrow;
		var $newcolumn;
		var $counter;
		var $quadrownumber;
		var $quadcolumnnumber;

		function init2($x,$y,$board,$shipname){
			$this->x=$x;
			$this->y=$y;
			$this->shipname=$shipname;
			$this->quadsize=$board->quadsize;
			$this->newrow=0;
			$this->newcolumn=0;
			$this->counter=0;
			//place ship in quadrant
			$this->quadrownumber=get_quadnumber($x,$this->quadsize);
			$this->quadcolumnnumber=get_quadnumber($y,$this->quadsize);
			$this->x=$x;
			$this->y=$y;
			//$this->setdirection(angle,speed);
			$this->quadsize=$board->quadsize;	
			$this->newrow=0;
			$this->newcolumn=0;
			$this->counter=0;
			$this->move_ship($x,$y,$board);
		}
		function move_ship($new_x,$new_y,$board) {//place ship in quadrant
			$this->quadrownumber=get_quadnumber($this->x,$this->quadsize);
			$this->quadcolumnnumber=get_quadnumber($this->y,$this->quadsize);
			$ship=$this;
			//delete ship from quadrant if already there(maybe this can be optimized)
			$ships_in_quadrant =$board->quadlist[$this->quadrownumber][$this->quadcolumnnumber]->ships;
			foreach($ships_in_quadrant as &$ship2) {
				$quad_ship =$ship2;
				if($quad_ship==$ship) {
					remove_element_from_array($board->quadlist[$this->quadrownumber][$this->quadcolumnnumber]->ships,$quad_ship);
				}
			}
			$this->quadrownumber=get_quadnumber($new_x,$this->quadsize);
			$this->quadcolumnnumber=get_quadnumber($new_y,$this->quadsize);		
			array_push($board->quadlist[$this->quadrownumber][$this->quadcolumnnumber]->ships, $ship);
		}		
	}
	function scan_quardan_for_other_ships($ship2) {
		$FOUND=false;
		$other_shipX;
		$other_shipY;
		$othership;
		foreach($ship_array as $ship) {
			if($ship==$ship2) continue;//skip currect ship
			if(get_quadnumber($ship2->x,$board->quadsize)==get_quadnumber($ship->x,$board->quadsize) && get_quadnumber($ship2->y,$board->quadsize)==get_quadnumber($ship->y,$board->quadsize)) {//same quadrant
				$FOUND=true;
				$other_shipX=$ship->x;
				$other_shipY=$ship->y; 
				$othership=$ship;
				break;
			}
		}
		if($FOUND) {
			 echo("same quadrant\n");
		} else {
			echo("different quadrant\n");
		}
	}
	function print_ships_quadrant($row,$columb,$board) {
		foreach($board->quadlist[$row][$columb]->ships as $ship) {
				echo("ship in quad row:".$row."columb".$columb."shipname:".$ship->shipname."\n");
		}
	}

	function print_ships_quadrant_and_adjacent_quadrants($row,$columb,$board) {
		print_ships_quadrant($row,$columb,$board);
		//top
		if(!($row-1<0)) {
			print_ships_quadrant($row-1,$columb,$board);
		}
		//bottom
		if(!($row+1>$board->height)) {
			print_ships_quadrant($row+1,$columb,$board);
		}
		//left
		if(!($columb-1<0)) {
			print_ships_quadrant($row,$columb-1,$board);
		}
		//right
		if(!($columb+1>$board->height)) {
			print_ships_quadrant($row,$columb+1,$board);
		}
		//topleft
		if(!($row-1<0)&&!($columb-1<0)) {
			print_ships_quadrant($row-1,$columb-1,$board);
		}
		//topright
		if(!($row-1<0)&&!($columb+1>$board->height)) {
			print_ships_quadrant($row-1,$columb+1,$board);
		}
		//bottomleft
		if(!($row+1>$board->height)&&!($columb-1<0)) {
			print_ships_quadrant($row+1,$columb-1,$board);
		}
		//bottomright
		if(!($row+1>$board->height)&&!($columb+1>$board->height)) {
			print_ships_quadrant($row+1,$columb+1,$board);
		}
	}


/*
	$width=1000;
	$height=1000;
	$board = new Board();
	$board->init2(100,$width,$height);
	$ship_array= array();//ship array

	$ship1= new Ship_class();
	$ship1->init2(50,50,$board,"nautilus");
	array_push($ship_array, $ship1);
	$ship2= new Ship_class();
	$ship2->init2(60,60,$board,"enterprise");
	array_push($ship_array, $ship2);
	$ship3= new Ship_class();
	$ship3->init2(250,250,$board,"voyager");
	array_push($ship_array, $ship2);
	$ship2->move_ship(700,700,$board);

	echo("ships in 1,1 and adjacent\n");
	print_ships_quadrant_and_adjacent_quadrants(1,1,$board);
	echo("ships in 7,7\n");
	print_ships_quadrant(7,7,$board);
	*/
?>
