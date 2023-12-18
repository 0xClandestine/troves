import hashlib
import random

print("Phase 1: Peggy sends y to Victor, Victor stores y as Peggy\"s token ")
print("Phase 2: Peggy wants to log in, She sends t to Victor ")
print("Phase 3: Victor validates Peggy\'s login request ")
print("Phase 4: Peggy receives c and calculates r = v - cx, sends r to Victor\n ")

password = input("Enter your secret: ")

n = 212502977571083929229027362384765066261
g = 11

x = int(hashlib.sha256(password.encode()).hexdigest(), 16) % n
y = pow(g, x, n)

v = random.randint(n, 2**256-1)
t = pow(g, v, n)

c = 728815563385977040452943777879061427756277306518
r = (int(v) - int(c) * x) % (n - 1)

print("\nx = hash(password)")
print("y = g**x % n")
print("v = random")
print("t = g**v % n")
print("c = random")
print("r = (v - cx) % (n - 1)\n")

print(f"x:\t {x}")
print(f"y:\t {y}")
print(f"v:\t {v}")
print(f"t:\t {t}")
print(f"c:\t {c}")
print(f"r:\t {r}")