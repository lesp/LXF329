#!/usr/bin/env python3
import pygame
import os
import random
import time

def get_random_image(image_folder):
    images = [f for f in os.listdir(image_folder) if f.lower().endswith(('png', 'jpg', 'jpeg', 'bmp', 'gif'))]
    if not images:
        raise FileNotFoundError("No images found in the folder.")
    return os.path.join(image_folder, random.choice(images))

def display_image(screen, image_path):
    """Loads, rotates, and displays an image on the screen."""
    image = pygame.image.load(image_path)
    image = pygame.transform.rotate(image, -90)
    image = pygame.transform.scale(image, (screen.get_width(), screen.get_height()))
    screen.blit(image, (0, 0))
    pygame.display.update()

while True:
    image_folder = "/home/pi/LXFPics/covers"
    pygame.init()
    screen = pygame.display.set_mode((800, 480), pygame.FULLSCREEN)
    pygame.display.set_caption("Random Image Viewer")
    running = True
    while running:
        try:
            image_path = get_random_image(image_folder)
            display_image(screen, image_path)
        except FileNotFoundError as e:
            print(e)
            running = False
        for _ in range(300):
            for event in pygame.event.get():
                if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
                    running = False
                    break
            time.sleep(1)
    pygame.quit()
