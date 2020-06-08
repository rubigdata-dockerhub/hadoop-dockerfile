import math
import multiprocessing as mp
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

        yield material + ' ' + weapon + ' was sold for ' + str(int(price)) + 'gp\n'


def serve(socket):
    dg = data_generator()
    while True:
        try:
            conn, addr = socket.accept()
            print('Connected by', addr)
            while True:
                time.sleep(random.uniform(0.0001, 0.02))
                conn.send(next(dg).encode('utf-8'))
        except:
            print('Disconnected by', addr)


def main():
    num_workers = 5

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(('0.0.0.0', 9999))
    server.listen(5)

    workers = [mp.Process(target=serve, args=(server,)) for i in range(num_workers)]
    for p in workers:
        p.daemon = True
        p.start()

    while True:
        try:
            time.sleep(10)
        except:
            break

    server.close()


if __name__ == '__main__':
    main()

