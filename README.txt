Carl Klier
HW2 ReadMe

The file structure of the HW2 folder looks like:

HW2
 - data
	- 1860_towns.jpg
	- 1860_towns_edges.jpg
	- cities.txt
	- collaboration.txt
	- roads.txt
 - Astar.pde
 - AstarLarge.pde
 - CityAndRoad.pde
 - Dikstras.pde
 - dynamic.pde
 - Graph.pde
 - Greedy.pde
 - Heuristic.pde
 - HW2.pde
 - pathfollowing.pde
 - PathFollowing.webm (in order to run this video, just drag and drop it into a Chrome tab)
 - PathFollowingGraph.pde
 - utils.pde
 
 The project is basically separated into two parts: the first part is used to run
 Dijkstra's and Astar algorithms on the small and large graph. The second part is 
 used to run Astar on the grid graph to show pathfollowing.
 
 
 ----------------------------------------------------------------------------
 First Part: DijkStra and Astar
 
 In order to run Dijkstra's and Astar algorithms for the small and large graphs
 you need to run the code in the HW2.pde file by uncommenting certain lines of code in that file.
 
 First, make sure the code in PathFollowingGraph.pde below line 364 is all commented out.
 This is to "turn off" the code to run the pathfollowing as we only want to look at the first part of
 the project that runs Dijkstra and Astar on the small and large graphs
 
 To run DijkStra's on the small graph, uncomment the code block starting at line 11.
 make sure the other large code blocks for the other algorithms and graphs are commented out.
 In the draw method, uncomment the 3 lines starting at line 83.
 Also change the frame rate to something between 10-20.
 
 To run Astar on the small graph, uncomment the block starting at line 22.
 Comment out either line 22 or 23 depending on which heuristic you want to use.
 In the draw method, uncomment the 3 lines starting at line 83.
 Also change the frame rate to something like 20.
 
 To run Dijkstra on the large graph, uncomment the block starting at line 42
 In the draw method, comment back out the 3 lines starting at 83.
 In the draw method, uncomment the 3 lines starting at line 89.
 Also change the frame rate to something like 2000 so the search runs quickly.
 
 To run Astar with the custom heuristic estimating the average distance between any two nodes
 uncomment the code block starting at like 62
 In the draw method, comment back out the 3 lines starting at 83.
 In the draw method, uncomment the 3 lines starting at line 89.
 Also change the frame rate to something like 2000 so the search runs quickly.
 
 
----------------------------------------------------------------------------
 Second Part: Pathfollowing
 
 To see the Pathfollowing algorithm in action, watch the video titled
 PathFollowing.webm in the HW2 folder. This video can be ran by dragging and dropping
 into a web browser such as a Chrome tab.
 
  In order to run the Pathfollowing algorithm
 you need to run the code in the PathFollowingGraph.pde file by uncommenting certain lines of code in that file.
 
 Start by commenting out everything in the HW2.pde file. We won't use those global variables, setup() or draw() methods.
 We will run the draw() and setup() methods of the PathFollowingGraph.pde file.
 
 Uncomment all the lines of code starting from line 364.
 
 Press the play button and click a point. Watch the Astar generate a shortest path and then
 the boid will follow that shortest path to the goal node.
 
 To select a different point, exit the program, re-run the program, and select a different point.
 
 ------------------------------------------------------------
 Description of important files and methods
 
 The CityAndRoad.pde file contains the City class which represents a node in my small graph.
 The Road class represents an edge in my small graph.
 For my large graph, I resused the same City and Road classes for my nodes and edges.
 It might seem weird, but it was just easier to reuse that data structure.
 
 Graph.pde contains the code to create my small and large graphs.
 The small graph is an instance of the Graph object and is created by calling the createCities
 and createRoads methods.
 The large graph is an instance of the LargeGraph object and is created by calling the CreateCollabs method
 and the createCollabEdges method.
 I needed to create separate graph objects becuase the small graph and large graph had
 different formats for listing their nodes and edges so I had to use different methods to create them.
 
 The Greedy.pde file isn't used currently but was used for testing initially since we were given a correct greedy algorithm.
 
 The Heuristic.pde file contains the heuristics I used for the small graph.
 However for the large graph, the custom heurisic used is actually in the AstarLarge.pde file.
 
 The PathFollowingGraph.pde file contains the code to create a grid structed graph. I went with the grid structure becuase it was
 easier to implement quantization with. This file contains methods to quantize based on a mouse click to the grid structure.
 It also has a method to call the movement algorithms on the boid once the shortest path is computed.
 
 the dynamic.pde, pathfollowing.pde, and utils.pde were given to us as example code.
 
 ----------------------------------------------------------------------
 References
 
My small graph was based off of a map of the cities of North Carolina towns in 1860 found at https://www.ncpedia.org/media/map/north-carolina-towns-1860. I also used that image as the background in my processing file HW2.pde.

The dataset for my large graph was found at http://networksciencebook.com/translations/en/resources/data.html and is the file collaboration.edglist found in the downloadable zip file at that website. The provided reference is: Ref: Leskovec, J., Kleinberg, J., & Faloutsos, C. (2007). Graph evolution: Densification and shrinking diameters. ACM Transactions on Knowledge Discovery from Data (TKDD), 1(1), 2.

https://en.wikipedia.org/wiki/Small-world_network and https://en.wikipedia.org/wiki/Co-occurrence_network were used to determine how to create a custom heuristic based off of the expected shortest path distance between any two nodes for my large graph.

Parts of the code for this project were given to us by Dr. Loftin and some parts of the code were based off lecture materials and PowerPoints provided. 

 
 