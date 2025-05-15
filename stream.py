import math
import multiprocessing as mp
import random
import socket
import time


def data_generator():
    #(material, website mean + distributor)
    materials = [('Bronze', 1803-500), ('Iron', 2976+0), ('Steel', 1913+0), ('Black', 4585+1000),
                 ('White', 3224+500), ('Mithril', 3631+1000), ('Adamant', 6569+0), ('Rune', 14553+0), ('Dragon', 70021+0)]

    #(weapon, website factor)
    weapons = [('Dagger', 0.3), ('Hatchet', 0.6), ('Mace', 0.5), ('Sword', 0.4), ('Scimitar', 0.9),
               ('Spear', 0.9), ('Hasta', 0.5), ('Longsword', 0.9), ('Warhammer', 1.5), ('Battleaxe', 1.6),
               ('Claw', 0.8), ('Two-handed sword', 1.8), ('Halberd', 2.3)]
    n_weapons = len(weapons)

    while True:
        mat_i = random.randint(0, len(materials) - 1)
        weap_i = random.randint(0, n_weapons - 1)

        material = materials[mat_i]
        weapon = weapons[weap_i]

        mean = material[1] * weapon[1]
        stdev = math.sqrt(material[1])

        price = random.gauss(mean, stdev)

        yield material[0] + ' ' + weapon[0] + ' was sold for ' + str(int(price)) + 'gp\n'


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

