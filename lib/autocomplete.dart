

Trie trie = Trie();
Set<String> suggestion = {};


class Node {
  final Map<String, dynamic> children = {};
  var isEndWord = false;
}

class Trie {
  Node root = Node();

  insert(String word) {
    var current = root;
    for (int i = 0; i < word.length; i++) {
      var char = word[i];
      if (!current.children.containsKey(char)) {
        current.children[char] = Node();
      }
      current = current.children[char]!;
    }
    current.isEndWord = true;
  }

  void delete(String word) {
    _delete(root, word, 0);
  }

  bool _delete( Node current, String word, int index) {
    if (index == word.length) {
      if (!current.isEndWord) {
        return false; 
      }
      current.isEndWord = false;
      return current.children.isEmpty;
    }

    String char = word[index];
    Node ?node = current.children[char];
    if (node == null) {
      return false; 
    }

    bool shouldDeleteCurrentNode = _delete(node, word, index + 1);

    if (shouldDeleteCurrentNode) {
      current.children.remove(char);
      return current.children.isEmpty && !current.isEndWord;
    }

    return false;
  }

  List<String> autocomplete(String prefix) {
    var current = root;
    for (var char in prefix.split('')) {
      if (!current.children.containsKey(char)) {
        return [];
      }
      current = current.children[char]!;
    }
   List<String> newsugg = suggestion.toList();

    _findsuggestion(current, prefix, newsugg);
    return newsugg;
  }

  _findsuggestion(Node root, String prefix, List<String> suggestion) {
    if (root.isEndWord) {
      suggestion.add(prefix);
    }
    root.children.forEach((char, childNode) =>
        _findsuggestion(childNode, prefix + char, suggestion));
  }
}
