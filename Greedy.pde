import java.util.HashSet;
import java.util.PriorityQueue;

class GreedyTag implements Comparable<GreedyTag> {
  City node;
  
  float ctg;
  Road edge;
  
  GreedyTag(City node, float ctg, Road edge) {
    this.node = node;
    this.ctg = ctg;
    this.edge = edge;
  }
  
  int compareTo(GreedyTag o) {
    if(this.ctg < o.ctg)
      return -1;
    else if(this.ctg > o.ctg)
      return 1;
    else
      return 0;
  }
}

class GreedyBestFirst implements GraphSearch {
  Heuristic heuristic; 
  
  City goal;
  
  HashMap<City,GreedyTag> tags;
  
  PriorityQueue<GreedyTag> open;
  HashSet<City> closed;
  
  GreedyBestFirst(Heuristic heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(City start, City goal, HashMap<String, City> cities) {
    this.goal = goal;
    
    tags = new HashMap<City,GreedyTag>();
  
    open = new PriorityQueue<GreedyTag>();
    closed = new HashSet<City>();
    
    GreedyTag tag = new GreedyTag(start, heuristic.value(start, goal), null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       GreedyTag tag = open.poll();
       
       if(null != tag && !closed.contains(tag.node)) {
          for(Road edge : tag.node.outgoing) {
            if(!tags.containsKey(edge.end)) {
              float ctg = heuristic.value(edge.end, goal);
              GreedyTag next_tag = new GreedyTag(edge.end, ctg, edge);
              
              tags.put(edge.end, next_tag);
              open.add(next_tag);
            }
            
            if(edge.end == goal)
              break;
          }
          
          closed.add(tag.node);
       }
    }
  } // end update
  
  List<Road> shortestPath() {
    if(tags.containsKey(goal)) {
      ArrayList<Road> path = new ArrayList<Road>();
      
      GreedyTag tag = tags.get(goal);
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
      
      return path;
    } else {
      return null;
    }
  }
  
  Collection<City> openSet() {
    if(null != open) {
      ArrayList<City> list = new ArrayList<City>();
    
      for(GreedyTag tag : open)
        list.add(tag.node);
    
      return list;
    } else {
      return null;
    }
  }
  
  Collection<City> closedSet() {
    return closed; 
  }
}
