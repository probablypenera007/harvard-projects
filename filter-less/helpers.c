#include "helpers.h"
#include "math.h"

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
  for (int row = 0; row < height; row++)
  {
    for (int col = 0; col < width; col++)
    {
        int avg = round((image[row][col].rgbtRed + image[row][col].rgbtGreen + image[row][col].rgbtBlue) / 3.0);
        image[row][col].rgbtRed = image[row][col].rgbtGreen = image[row][col].rgbtBlue = avg;
    }
  }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    int sepiaRed, sepiaGreen, sepiaBlue;
       for (int row = 0; row < height; row++)
  {
    for (int col = 0; col < width; col++)
    {
        sepiaRed = round (0.393 * image[row][col].rgbtRed + 0.769 * image[row][col].rgbtGreen + 0.189 * image[row][col].rgbtBlue);
        sepiaGreen = round (0.349 * image[row][col].rgbtRed + 0.686 * image[row][col].rgbtGreen + 0.168 * image[row][col].rgbtBlue);
        sepiaBlue = round (0.272 * image[row][col].rgbtRed + 0.534 * image[row][col].rgbtGreen + 0.131 * image[row][col].rgbtBlue);
    image[row][col].rgbtRed = sepiaRed > 255? 255: sepiaRed;
    image[row][col].rgbtGreen = sepiaGreen > 255? 255: sepiaGreen;
    image[row][col].rgbtBlue = sepiaBlue > 255? 255: sepiaBlue;
    }
  }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE original[height][width];

    for (int row = 0; row < height; row++)
    {
        for (int col = 0; col < width; col++)
        {
            original[row][col] = image[row][col];
        }
    }
     for (int row = 0; row < height; row++)
    {
        for (int col = 0, swap = width - 1; col < width; col++)
        {
            image[row][col] = original[row][swap];
            swap --;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
     RGBTRIPLE original[height][width];

    for (int row = 0; row < height; row++)
    {
        for (int col = 0; col < width; col++)
        {
            original[row][col] = image[row][col];
        }
    }
    int totalr, totalg, totalb;
    int count = 0;
    totalr = totalg = totalb = 0;

    for (int row = 0; row < height; row++)
    {
        for (int col = 0; col < width; col++)
        {
            for (int arrow = row -1; arrow <= row+1; arrow++)
            {
                for (int arrcol = col -1; arrcol <= col +1; arrcol++)
                {
                    if (arrcol < width && arrow < height && arrcol >= 0 && arrow >= 0)
                    {
                    totalr += original[arrow][arrcol].rgbtRed;
                    totalg += original[arrow][arrcol].rgbtGreen;
                    totalb += original[arrow][arrcol].rgbtBlue;
                    count++;
                    }
                }
            }
                image[row][col].rgbtRed = round(totalr / count);
                image[row][col].rgbtGreen = round(totalg / count);
                image[row][col].rgbtBlue = round(totalb / count);
                count = 0;
                totalr = totalg = totalb = 0;
        }
    }
    return;
}
