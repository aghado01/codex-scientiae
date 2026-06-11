[Page 535]

x1 x2 x3

| | | |
|---|---|---|
| | | |


| | | |
|---|---|---|
| | | |


fa fb

| | |
|---|---|
| | |
| | |


fc

x4

x1 x2 x3

| | |
|---|---|
| | |


| | |
|---|---|
| | |


| | |
|---|---|
| | |


| | |
|---|---|
| | |


f˜a1 f˜a2 f˜b2 f˜b3 f˜c2

| | |
|---|---|
| | |


f˜c4

| | |
|---|---|
| | |


x4

- Figure 10.18 On the left is a simple factor graph from Figure 8.51 and reproduced here for convenience. On the right is the corresponding factorized approximation.


fb(x2,x3) = fb2(x2) fb3(x3). We ﬁrst remove this factor from the approximating distribution to give

q\b(x) = fa1(x1) fa2(x2) fc2(x2) fc4(x4) (10.228) and we then multiply this by the exact factor fb(x2,x3) to give

###### p(x) = q\b(x)fb(x2,x3) = fa1(x1) fa2(x2) fc2(x2) fc4(x4)fb(x2,x3). (10.229)

We now ﬁnd qnew(x) by minimizing the Kullback-Leibler divergence KL( p qnew). The result, as noted above, is that qnew(z) comprises the product of factors, one for each variable xi, in which each factor is given by the corresponding marginal of p(x). These four marginals are given by

p(x1) ∝ fa1(x1) (10.230) p(x2) ∝ fa2(x2) fc2(x2)

fb(x2,x3) (10.231)

x3

p(x3) ∝

fb(x2,x3) fa2(x2) fc2(x2) (10.232)

x2

p(x4) ∝ fc4(x4) (10.233) and qnew(x) is obtained by multiplying these marginals together. We see that the only factors in q(x) that change when we update fb(x2,x3) are those that involve the variables in fb namely x2 and x3. To obtain the reﬁned factor fb(x2,x3) = fb2(x2) fb3(x3) we simply divide qnew(x) by q\b(x), which gives

- fb2(x2) ∝ x3

fb(x2,x3) (10.234)

- fb3(x3) ∝ x2


fb(x2,x3) fa2(x2) fc2(x2) . (10.235)
