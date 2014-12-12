(function() {
	var config = {
		forest: [
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 5, 4, 4, 8, 3, 3, 4, 6, 3, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 1, 4, 5, 1, 1, 1, 4, 5, 1, 7, 1, 3, 5, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 4, 9, 4, 9, 6, 7, 5, 5, 5, 8, 7, 6, 6, 8, 5, 0, 0, 0, 0],
			[0, 0, 0, 3, 7, 2, 9, 8, 3, 5, 6, 7, 3, 9, 1, 8, 7, 5, 8, 5, 0, 0, 0],
			[0, 0, 0, 1, 4, 7, 8, 4, 2, 9, 2, 7, 1, 1, 8, 2, 2, 7, 6, 3, 0, 0, 0],
			[0, 0, 7, 2, 1, 8, 5, 5, 3, 1, 1, 3, 1, 3, 3, 4, 2, 8, 6, 1, 3, 0, 0],
			[0, 0, 4, 2, 6, 7, 2, 5, 2, 4, 2, 2, 5, 4, 3, 2, 8, 1, 7, 7, 3, 0, 0],
			[0, 0, 4, 1, 6, 5, 1, 1, 1, 9, 1, 4, 3, 4, 4, 3, 1, 9, 8, 2, 7, 0, 0],
			[0, 4, 3, 5, 2, 3, 2, 2, 3, 2, 4, 2, 5, 3, 5, 1, 1, 3, 5, 5, 3, 7, 0],
			[0, 2, 7, 1, 5, 1, 1, 3, 1, 5, 3, 3, 2, 4, 2, 3, 7, 7, 5, 4, 2, 7, 0],
			[0, 2, 5, 2, 2, 6, 1, 2, 4, 4, 6, 3, 4, 1, 2, 1, 2, 6, 5, 1, 8, 8, 0],
			[0, 0, 4, 3, 7, 5, 1, 9, 3, 4, 4, 5, 2, 9, 4, 1, 9, 5, 7, 4, 8, 0, 0],
			[0, 0, 4, 1, 6, 7, 8, 3, 4, 3, 4, 1, 3, 1, 2, 3, 2, 3, 6, 2, 4, 0, 0],
			[0, 0, 7, 3, 2, 6, 1, 5, 3, 9, 2, 3, 2, 1, 5, 7, 5, 8, 9, 5, 4, 0, 0],
			[0, 0, 0, 1, 6, 7, 3, 4, 8, 1, 1, 1, 2, 1, 2, 2, 8, 9, 4, 1, 0, 0, 0],
			[0, 0, 0, 2, 5, 4, 7, 8, 7, 5, 6, 1, 3, 5, 7, 8, 7, 2, 9, 3, 0, 0, 0],
			[0, 0, 0, 0, 6, 5, 6, 4, 6, 7, 2, 5, 2, 2, 6, 3, 4, 7, 4, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 2, 3, 1, 2, 3, 3, 3, 2, 1, 3, 2, 1, 1, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 7, 4, 4, 5, 7, 3, 4, 4, 7, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		],

		dirs: [
			{ x: -1,  y:  0 }, // N
			{ x: -1,  y:  1 }, // NE
			{ x:  0,  y:  1 }, // E
			{ x:  1,  y:  1 }, // SE
			{ x:  1,  y:  0 }, // S
			{ x:  1,  y: -1 }, // SW
			{ x:  0,  y: -1 }, // W
			{ x: -1,  y: -1 }  // NW
		],

		origin: { x: 11, y: 11, dir: { x: 0, y: 0 }, parent: null }
	};

	function run (config) {
		var forest = config.forest,
			dirs   = config.dirs,
			origin = config.origin;

		function jumpTo (from, dir, days) {
			return {
				x:  from.x + dir.x*days,
				y:  from.y + dir.y*days,
				dir: dir
			};
		}

		function jumpBackOnce (from) {
			var dir = from.dir;

			return jumpTo(from, { x: -dir.x, y: -dir.y }, 1);
		}

		function getNeighbors (point) {
			var from = point,
				days = forest[point.x][point.y];

			return dirs.map(function (dir) {
				return jumpTo(from, dir, days);
			});
		}

		function inBounds (point) {
			var x = point.x,
				y = point.y,
				length = forest.length;

			return x >= 0 && x < length && y >= 0 && y < length;
		}

		function isVisited (point, queue) {
			var x = point.x,
				y = point.y;

			return queue.some(function (point) {
				return point.x == x && point.y == y;
			});
		}

		function isOutside (point) {
			return forest[point.x][point.y] === 0;
		}

		function isInside (point) {
			return !isOutside(point);
		}

		function buildPathFrom (target, queue) {
			var path = [];

			do {
				path.unshift('(' + (target.x + 1) + ', ' + (target.y + 1) + ')');
			} while (typeof (target = queue[target.parent]) == "undefined");

			return path.join(' -> ');
		}

		function visitNeighbours (index, queue) {
			var origin, neighbours, back;

			// Check completion
			if (index >= queue.length) {
				return;
			}

			origin = queue[index];
			updateCell(origin);

			neighbours = getNeighbors(origin);
			// Enqueue origin neighbours
			for (var k = 0; k < neighbours.length; k++) {
				var neighbour = neighbours[k];
				// Sets parent node index
				neighbour.parent = index;
				if (inBounds(neighbour) && !isVisited(neighbour, queue)) {
					// Check exit
					back = jumpBackOnce(neighbour);
					if (isInside(back) && isOutside(neighbour)) {
						updateCell(neighbour, true);
						continue;
					}

					if(isInside(neighbour)) {
						queue.push(neighbour);
						updateCell(neighbour);
					}
				}
			}
			setTimeout(function() {
				visitNeighbours(index + 1, queue);
			}, 10);
		}

		visitNeighbours(0, [origin]);
	}

	function renderPuzzle(data) {
	    // DATA JOIN
	    var tr = tbody.selectAll("tr")
	        .data(data);
	    var td = tr.selectAll("td")
	        .data(function(d) { return d; });

	    // ENTER
	    tr.enter()
			.append("tr");
		td.enter()
			.append("td")
			.classed("cell", true)
			.html(function(d) {
				return d.value > 0 ? d.value.toString() : "";
			});

		// ENTER + UPDATE
		td.classed("selected", function(d) {
			return d.selected;
		});
		// ENTER + UPDATE
		td.classed("exit", function(d) {
			return d.exit;
		});
		td.style("background-color", function(d) {
			if (d.selected && !d.exit) {
				return d3.rgb(77, 144, 254).darker(d.touch).toString();
			}
		});

		// EXIT
		td.exit()
			.remove();
	}

	function prepareData (data) {
		return data.map(function(row, x) {
		    return row.map(function(column, y) {
		        return { 'x': x, 'y': y, 'value': column, 'touch': 0 };
		    });
		});
	}

	function updateCell (cell, isExit) {
		data[cell.x][cell.y].selected = true;
		data[cell.x][cell.y].touch += 1;
		data[cell.x][cell.y].exit = isExit;
		renderPuzzle(data);
	}

	var data = prepareData(config.forest);

	var table = d3.select("body").append("table"),
	    tbody = table.append("tbody");

	renderPuzzle(data);
	run(config);
})();