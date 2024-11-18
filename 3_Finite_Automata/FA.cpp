#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <unordered_set>
#include <map>
#include <vector>

using namespace std;

struct Transition {
    string from_state;
    char symbol;
    string to_state;

    Transition(const string& from, char sym, const string& to)
            : from_state(from), symbol(sym), to_state(to) {}
};

void loadFA(const string& filename, unordered_set<string>& states, unordered_set<char>& alphabet,
            vector<Transition>& transitions, unordered_set<string>& final_states, string& start_state) {
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "Error: Could not open file " << filename << endl;
        exit(1);
    }

    string line;
    while (getline(file, line)) {
        istringstream iss(line);
        string type;
        iss >> type;

        if (type == "states:") {
            string state;
            while (iss >> state) {
                states.insert(state);
            }
        } else if (type == "alphabet:") {
            char symbol;
            while (iss >> symbol) {
                alphabet.insert(symbol);
            }
        } else if (type == "transition:") {
            string from_state, to_state;
            char symbol;
            iss >> from_state >> symbol >> to_state;
            transitions.push_back(Transition(from_state, symbol, to_state));
        } else if (type == "start:") {
            iss >> start_state;
        } else if (type == "final:") {
            string state;
            while (iss >> state) {
                final_states.insert(state);
            }
        }
    }
}

void displayFA(const unordered_set<string>& states, const unordered_set<char>& alphabet,
               const vector<Transition>& transitions, const unordered_set<string>& final_states, const string& start_state) {
    cout << "States: ";
    for (const auto& state : states) {
        cout << state << " ";
    }
    cout << "\nAlphabet: ";
    for (const auto& symbol : alphabet) {
        cout << symbol << " ";
    }
    cout << "\nTransitions:\n";
    for (const auto& t : transitions) {
        cout << t.from_state << " --" << t.symbol << "--> " << t.to_state << endl;
    }
    cout << "Start State: " << start_state << endl;
    cout << "Final States: ";
    for (const auto& state : final_states) {
        cout << state << " ";
    }
    cout << endl;
}

bool isValidToken(const string& input, const string& start_state, const vector<Transition>& transitions,
                  const unordered_set<string>& final_states) {
    string current_state = start_state;

    for (char symbol : input) {
        bool transition_found = false;
        for (const auto& t : transitions) {
            if (t.from_state == current_state && t.symbol == symbol) {
                current_state = t.to_state;
                transition_found = true;
                break;
            }
        }
        if (!transition_found) {
            return false;
        }
    }
    return final_states.find(current_state) != final_states.end();
}

int main() {
    unordered_set<string> states;
    unordered_set<char> alphabet;
    vector<Transition> transitions;
    unordered_set<string> final_states;
    string start_state;

    string filename = "FA.in";
    loadFA(filename, states, alphabet, transitions, final_states, start_state);

    displayFA(states, alphabet, transitions, final_states, start_state);

    string test_string;
    cout << "Enter a string to test if it is a valid token: ";
    cin >> test_string;

    if (isValidToken(test_string, start_state, transitions, final_states)) {
        cout << "The string \"" << test_string << "\" is a valid lexical token.\n";
    } else {
        cout << "The string \"" << test_string << "\" is NOT a valid lexical token.\n";
    }

    return 0;
}
