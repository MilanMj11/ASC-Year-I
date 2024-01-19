#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

ifstream fin("input.txt");
ofstream fout("output.txt");

const int NMAX = 105;
vector <int> v[NMAX];
int M[NMAX];
int D[NMAX][NMAX],Daux[NMAX][NMAX];
bool ver[NMAX];
int cerinta, n, node,k,sursa,destinatie;

void matrix_mult(int M1[105][105], int M2[105][105], int Mres[105][105], int n) {
	///memset(Mres, 0, sizeof(Mres));
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			Mres[i][j] = 0;
			for (int k = 0; k < n; k++) {
				Mres[i][j] += M1[i][k] * M2[k][j];
			}
		}
	}
}

int main() {
	fin >> cerinta;
	fin >> n;
	for (int i = 0; i < n; i++) {
		fin >> M[i];
	}
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < M[i]; j++) {
			fin >> node;
			v[i].push_back(node);
			D[i][node] = 1;
		}
	}
	if (cerinta == 1) {
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				fout << D[i][j] << " ";
			}
			fout << '\n';
		}
	}
	if (cerinta == 2) {
		fin >> k >> sursa >> destinatie;
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				Daux[i][j] = D[i][j];
			}
		}
		for (int pas = 2; pas <= k; pas++) {
			matrix_mult(Daux, D, D, n);
		}
		fout << D[sursa][destinatie];
	}
	
	return 0;
}