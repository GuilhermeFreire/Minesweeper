# Minesweeper
An AI prolog script capable of playing minesweeper

##Como rodar
1. Escreva todas as minas no arquivo `mina.pl`.
2. Abra o `criaAmbiente.pl` e rode `createFile()`.
  * Por padrão as dimensões do mapa são determinadas a partir da mina mais externa.
  * Para determinar a dimensão na mão, rode `createFile(DimX, DimY)` em vez de `createFile()`.
3. Agora o arquivo `ambiente.pl` foi gerado.
4. Para rodar a IA do jogo, abra `agente.pl` e rode `startGame()`.

##Mapas
* mina.pl
```
    1   2   3   4   5   
1 | X | X | 1 | 0 | 0 |
2 | X | 3 | 1 | 1 | 1 |
3 | 1 | 1 | 0 | 1 | X |
4 | 1 | 1 | 0 | 1 | 1 |
5 | X | 1 | 0 | 0 | 0 |
```

* mina2.pl
```
    1   2   3   4   5
1 | 1 | 2 | 1 | 1 | 0 |
2 | X | 2 | X | 1 | 0 |
3 | 1 | 2 | 1 | 2 | 1 |
4 | 0 | 0 | 0 | 1 | X |

```