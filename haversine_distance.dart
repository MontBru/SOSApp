import 'dart:math';

double haversine_distance(double coordinate1lng,double coordinate1lat,double coordinate2lng,double coordinate2lat)
{
  double R=6371.0710;//earth radius

  double radianslat1=coordinate1lat*(pi/180);
  double radianslat2=coordinate2lat*(pi/180);
  double radianslng1=coordinate1lng*(pi/180);
  double radianslng2=coordinate2lng*(pi/180);

  double latdiff=radianslat1-radianslat2;
  double lngdiff=radianslng1-radianslng2;

  double distance=2*R*asin(
    sqrt(
      sin(latdiff/2)*sin(latdiff/2)
          +cos(radianslat1)*cos(radianslat2)*
          sin(lngdiff/2)*sin(lngdiff/2)
    )
  );
  return distance;
}