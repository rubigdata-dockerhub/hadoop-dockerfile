import math
import numpy
import random
import socket
import time


def data_generator():
    materials = ['Bronze', 'Iron', 'Steel', 'Black',
                 'White', 'Mithril', 'Adamant', 'Rune', 'Dragon']
    weapons = ['Dagger', 'Sword', 'Scimitar', 'Mace',
               'Longsword', 'Hatchet', 'Battleaxe', 'Warhammer',
               'Two-handed sword', 'Pickaxe', 'Spear', 'Hasta',
               'Claws', 'Halberd', 'Defender']
    n_weapons = len(weapons)

    while True:
        mat_i = random.randint(0, len(materials) - 1)
        weap_i = random.randint(0, n_weapons - 1)

        material = materials[mat_i]
        weapon = weapons[weap_i]

        mean = (mat_i + 1) * 50000 * ((weap_i + n_weapons / 1.5) / n_weapons)
        stdev = math.sqrt(mean)
        price = numpy.random.normal(mean, stdev)

        yield ' '.join([material, weapon, str(int(price))]) + '\n'


def serve():
    dg = data_generator()
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(('127.0.0.1', '9999'))
        s.listen()
        conn, addr = s.accept()
        with conn:
            while True:
                time.sleep(random.uniform(0.0001, 0.02))
                conn.sendall(next(dg))
                conn.se


def main():
    serve()


if __name__ == '__main__':
    main()
