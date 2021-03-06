//================== On_Chart_Color_Palette.mq4 =====================/

//================== Declarations ===================================/

//+------------------------------------------------------------------+
//|                                       On_Chart_Color_Palette.mq4 |
//|                                Copyright 2019 github.com/alexvin8|
//+------------------------------------------------------------------+
#property copyright "github.com/alexvin8"
#property link      "https://github.com/alexvin8" 
#property version   "1.00"
#property description "This indicator shows Color Palette directly on the chart."
#property description "It gives ability to change color of all the selected objects"
#property description "and can create 2 types of the rectangles (unfilled and filled) and trendline"
#property description "by pushing the color buttons on the Color Palette."
//#property icon        "\\Images\\On_Chart_Color_Palette_icon.ico"; 
//----
#property strict
#property indicator_chart_window
//----
extern   string            _="";//>BUTTONS:
extern   bool              showLeftUpperPanel=true; //Show left upper button
extern   bool              showRightUpperPanel=true; //Show right upper button
extern   bool              showLeftLowerPanel=true; //Show left lower button
extern   bool              showRightLowerPanel=true; //Show right lower button
extern   string            __="";//>PALETTE BUTTONS PARAMETERS:
extern   int               sz=11;   // Size of palette buttons
extern   color             rect_icon_cl=clrLightGray;//Palette buttons border color
extern   int               rect_icon_wd=0;//Palette border width
extern   string            ___=""; //>LEFT UPPER BUTTON PARAMETERS:
extern   int               x_1=0; //X-coordinate
extern   int               y_1=80; //Y-coordinate
extern   string            ____=""; //>RIGHT UPPER BUTTON PARAMETERS:
extern   int               x_2=0; //X-coordinate
extern   int               y_2=80; //Y-coordinate
extern   string            _____=""; //>LEFT LOWER BUTTON PARAMETERS:
extern   int               x_3=0; //X-coordinate
extern   int               y_3=0; //Y-coordinate
extern   string            ______=""; //>RIGHT LOWER BUTTON PARAMETERS:
extern   int               x_4=0; //X-coordinate
extern   int               y_4=0; //Y-coordinate
extern   string            _______=""; //>BUTTON PARAMETERS:
extern   int               x_but=8; // Width
extern   int               y_but=16; //Length
extern   color             background_but=clrLightGray; //Background color
extern   color             border_but=clrGray; //Border color
//----
ENUM_LINE_STYLE  rect_icon_st            =  STYLE_SOLID;           // Icon border style 
ENUM_LINE_STYLE  line_st                 =  STYLE_SOLID;           // Trendline style
int              line_wd                 =  2;                     // Trendline width
//---
int
x_rec_1=140,y_rec_1=90,
x_pl,y_pl;
// For buttons
bool
InpSelection=false,// Выделить для перемещений
InpHidden=false,// Скрыт в списке объектов
InpHidden_OBJ=false,// Скрыт в списке объектов
InpBackRect=false,// Объект на заднем плане
//---
selected_LeftUpperButton_1,selected_RightUpperButton_1,
selected_LeftLowerButton_1,selected_RightLowerButton_1;
long
x_distance,y_distance;
string
plt_names[12][11]=
  {
   "Black","DarkGreen","DarkSlateGray","Olive","Green","Teal","Navy","Purple","Maroon","Indigo","MidnightBlue",
   "DarkBlue","DarkOliveGreen","SaddleBrown","ForestGreen","OliveDrab","SeaGreen","DarkGoldenrod","DarkSlateBlue","Sienna","MediumBlue","Brown",
   "DarkTurquoise","DimGray","LightSeaGreen","DarkViolet","FireBrick","MediumVioletRed","MediumSeaGreen","Chocolate","Crimson","SteelBlue","Goldenrod",
   "MediumSpringGreen","LawnGreen","CadetBlue","DarkOrchid","YellowGreen","LimeGreen","OrangeRed","DarkOrange","Orange","Gold","Yellow",
   "Chartreuse","Lime","SpringGreen","Aqua","DeepSkyBlue","Blue","Magenta","Red","Gray","SlateGray","Peru",
   "BlueViolet","LightSlateGray","DeepPink","MediumTurquoise","DodgerBlue","Turquoise","RoyalBlue","SlateBlue","DarkKhaki","IndianRed","MediumOrchid",
   "GreenYellow","MediumAquamarine","DarkSeaGreen","Tomato","RosyBrown","Orchid","MediumPurple","PaleVioletred","Coral","CornflowerBlue","DarkGray",
   "SandyBrown","MediumSlateBlue","Tan","DarkSalmon","BurlyWood","HotPink","Salmon","Violet","LightCoral","SkyBlue","LightSalmon",
   "Plum","Khaki","LightGreen","Aquamarine","Silver","LightSkyBlue","LightSteelBlue","LightBlue","PaleGreen","Thistle","PowderBlue",
   "PaleGoldenrod","PaleTurquoise","LightGray","Wheat","NavajoWhite","Moccasin","LightPink","Gainsboro","PeachPuff","Pink","Bisque",
   "LightGoldenrod","BlanchedAlmond","LemonChiffon","Beige","AntiqueWhite","PapayaWhip","Cornsilk","LightYellow","LightCyan","Linen","Lavender",
   "MistyRose","OldLace","WhiteSmoke","Seashell","Ivory","Honeydew","AliceBlue","LavenderBlush","MintCream","Snow","White"
  }
   ,
plt_names_clr[12][11]=
  {
   "clrBlack","clrDarkGreen","clrDarkSlateGray","clrOlive","clrGreen","clrTeal","clrNavy","clrPurple","clrMaroon","clrIndigo","clrMidnightBlue",
   "clrDarkBlue","clrDarkOliveGreen","clrSaddleBrown","clrForestGreen","clrOliveDrab","clrSeaGreen","clrDarkGoldenrod","clrDarkSlateBlue","clrSienna","clrMediumBlue","clrBrown",
   "clrDarkTurquoise","clrDimGray","clrLightSeaGreen","clrDarkViolet","clrFireBrick","clrMediumVioletRed","clrMediumSeaGreen","clrChocolate","clrCrimson","clrSteelBlue","clrGoldenrod",
   "clrMediumSpringGreen","clrLawnGreen","clrCadetBlue","clrDarkOrchid","clrYellowGreen","clrLimeGreen","clrOrangeRed","clrDarkOrange","clrOrange","clrGold","clrYellow",
   "clrChartreuse","clrLime","clrSpringGreen","clrAqua","clrDeepSkyBlue","clrBlue","clrMagenta","clrRed","clrGray","clrSlateGray","clrPeru",
   "clrBlueViolet","clrLightSlateGray","clrDeepPink","clrMediumTurquoise","clrDodgerBlue","clrTurquoise","clrRoyalBlue","clrSlateBlue","clrDarkKhaki","clrIndianRed","clrMediumOrchid",
   "clrGreenYellow","clrMediumAquamarine","clrDarkSeaGreen","clrTomato","clrRosyBrown","clrOrchid","clrMediumPurple","clrPaleVioletred","clrCoral","clrCornflowerBlue","clrDarkGray",
   "clrSandyBrown","clrMediumSlateBlue","clrTan","clrDarkSalmon","clrBurlyWood","clrHotPink","clrSalmon","clrViolet","clrLightCoral","clrSkyBlue","clrLightSalmon",
   "clrPlum","clrKhaki","clrLightGreen","clrAquamarine","clrSilver","clrLightSkyBlue","clrLightSteelBlue","clrLightBlue","clrPaleGreen","clrThistle","clrPowderBlue",
   "clrPaleGoldenrod","clrPaleTurquoise","clrLightGray","clrWheat","clrNavajoWhite","clrMoccasin","clrLightPink","clrGainsboro","clrPeachPuff","clrPink","clrBisque",
   "clrLightGoldenrod","clrBlanchedAlmond","clrLemonChiffon","clrBeige","clrAntiqueWhite","clrPapayaWhip","clrCornsilk","clrLightYellow","clrLightCyan","clrLinen","clrLavender",
   "clrMistyRose","clrOldLace","clrWhiteSmoke","clrSeashell","clrIvory","clrHoneydew","clrAliceBlue","clrLavenderBlush","clrMintCream","clrSnow","clrWhite"
  }
;
//
int
addbtn_1=1017,
addbtn_2=1016,
addbtn_3=1018;
//Для получения состояния клавиши SHIFT - 1016, CTRL - 1017, ALT - 1018
//Клавиши Left, Up, Right, Down - 1037,1038,1039,1040 соответственно
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("start oninit");
//---
   if(showLeftUpperPanel)
     {
      ButtonCreate(0,"PLT_LeftUpperButton_1",0,x_1,y_1,x_but,y_but,0,"",NULL,0,0,background_but,border_but,false,false,false,false,0);
      ObjectSetString(0,"PLT_LeftUpperButton_1",OBJPROP_TOOLTIP,"Palette");
     }
   if(showRightUpperPanel)
     {
      ButtonCreate(0,"PLT_RightUpperButton_1",0,x_2+x_but,y_2,x_but,y_but,1,"",NULL,0,0,background_but,border_but,false,false,false,false,0);
      ObjectSetString(0,"PLT_RightUpperButton_1",OBJPROP_TOOLTIP,"Palette");
     }
   if(showLeftLowerPanel)
     {
      ButtonCreate(0,"PLT_LeftLowerButton_1",0,x_3,y_3+y_but,x_but,y_but,2,"",NULL,0,0,background_but,border_but,false,false,false,false,0);
      ObjectSetString(0,"PLT_LeftLowerButton_1",OBJPROP_TOOLTIP,"Palette");
     }
   if(showRightLowerPanel)
     {
      ButtonCreate(0,"PLT_RightLowerButton_1",0,x_4+x_but,y_4+y_but,x_but,y_but,3,"",NULL,0,0,background_but,border_but,false,false,false,false,0);
      ObjectSetString(0,"PLT_RightLowerButton_1",OBJPROP_TOOLTIP,"Palette");
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObDeleteObjectsByPrefix("PLT");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   selected_LeftUpperButton_1 =ObjectGetInteger(0,"PLT_LeftUpperButton_1"  ,OBJPROP_STATE);
   selected_RightUpperButton_1=ObjectGetInteger(0,"PLT_RightUpperButton_1" ,OBJPROP_STATE);
   selected_LeftLowerButton_1 =ObjectGetInteger(0,"PLT_LeftLowerButton_1"  ,OBJPROP_STATE);
   selected_RightLowerButton_1=ObjectGetInteger(0,"PLT_RightLowerButton_1" ,OBJPROP_STATE);
//----
//--- set window size
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//----
   if((id==CHARTEVENT_OBJECT_CLICK) && (sparam=="PLT_LeftUpperButton_1"))
     {
      //--- State of the button - pressed or not
      if(selected_LeftUpperButton_1)
        {
         selected_RightUpperButton_1=false;
         selected_LeftLowerButton_1 =false;
         selected_RightLowerButton_1=false;
         ObjectSetInteger(0,"PLT_RightUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_LeftLowerButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_RightLowerButton_1",OBJPROP_STATE,false);
         x_pl=x_1+sz;
         y_pl=y_1;
         CreatePalette();
        }
      else
        {
         ObDeleteObjectsByPrefix("PLT_name");
        }
     }
   if((id==CHARTEVENT_OBJECT_CLICK) && (sparam=="PLT_RightUpperButton_1"))
     {
      //--- State of the button - pressed or not
      if(selected_RightUpperButton_1)
        {
         selected_LeftUpperButton_1 =false;
         selected_LeftLowerButton_1 =false;
         selected_RightLowerButton_1=false;
         ObjectSetInteger(0,"PLT_LeftUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_LeftLowerButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_RightLowerButton_1",OBJPROP_STATE,false);
         x_pl=x_distance-sz*12-x_2;
         y_pl=y_2;
         CreatePalette();
        }
      else
        {
         ObDeleteObjectsByPrefix("PLT_name");
        }
     }
   if((id==CHARTEVENT_OBJECT_CLICK) && (sparam=="PLT_LeftLowerButton_1"))
     {
      //--- State of the button - pressed or not
      if(selected_LeftLowerButton_1)
        {
         selected_LeftUpperButton_1 =false;
         selected_RightUpperButton_1=false;
         selected_RightLowerButton_1=false;
         ObjectSetInteger(0,"PLT_LeftUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_RightUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_RightLowerButton_1",OBJPROP_STATE,false);
         x_pl=x_3+sz;
         y_pl=y_distance-y_3-sz*12;
         CreatePalette();
        }
      else
        {
         ObDeleteObjectsByPrefix("PLT_name");
        }
     }
   if((id==CHARTEVENT_OBJECT_CLICK) && (sparam=="PLT_RightLowerButton_1"))
     {
      //--- State of the button - pressed or not
      if(selected_RightLowerButton_1)
        {
         selected_LeftUpperButton_1 =false;
         selected_RightUpperButton_1=false;
         selected_LeftLowerButton_1=false;
         ObjectSetInteger(0,"PLT_LeftUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_RightUpperButton_1",OBJPROP_STATE,false);
         ObjectSetInteger(0,"PLT_LeftLowerButton_1",OBJPROP_STATE,false);
         x_pl=x_distance-sz*12-x_4;
         y_pl=y_distance-y_4-sz*12;
         CreatePalette();
        }
      else
        {
         ObDeleteObjectsByPrefix("PLT_name");
        }
     }
//----
   datetime dt_1     = 0;
   double   price_1  = 0;
   datetime dt_2     = 0;
   double   price_2  = 0;
   int      window   = 0;
   int      x        = 0;
   int      y        = 0;
//--
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if((selected_LeftUpperButton_1) || (selected_LeftLowerButton_1))
        {
         int i,j;
         for(i=0;i<12;i++)
           {
            for(j=0;j<11;j++)
              {
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl+13*sz,y_pl,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl+13*sz+35,y_pl+15,window,dt_2,price_2);
                  RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,StringToColor(plt_names_clr[i][j]),STYLE_SOLID,0,true,false,true,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==true) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl+13*sz,y_pl+45,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl+13*sz+35,y_pl+45,window,dt_2,price_2);
                  TrendCreate(0,name,0,dt_1,price_1,dt_2,price_2,StringToColor(plt_names_clr[i][j]),line_st,line_wd,InpBackRect,true,false,false,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==true) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl+13*sz,y_pl+20,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl+13*sz+35,y_pl+35,window,dt_2,price_2);
                  RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,StringToColor(plt_names_clr[i][j]),STYLE_SOLID,1,false,false,true,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==true))
                 {
                  int      m,objects_total_number;
                  string   object_name;
                  //----
                  objects_total_number=ObjectsTotal(-1);
                  if(objects_total_number>=1)
                    {
                     for(m=objects_total_number; m>=0; m--)
                       {
                        object_name=ObjectName(m);
                        if(ObjectGetInteger(0,object_name,OBJPROP_SELECTED)==true)
                          {
                           if(ObjectType(object_name)!=OBJ_FIBOTIMES)
                             {
                              ObjectSet(object_name,OBJPROP_COLOR,StringToColor(plt_names_clr[i][j]));
                             }
                           //if(ObjectType(object_name)!=OBJ_FIBOTIMES)
                           //  {
                           //   ObjectSet(object_name,OBJPROP_COLOR,StringToColor(plt_names_clr[i][j]));
                           //  }
                           ObjectSet(object_name,OBJPROP_LEVELCOLOR,StringToColor(plt_names_clr[i][j]));
                          }
                       }
                    }
                 }
              }
           }
        }
     }
//----
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if((selected_RightUpperButton_1) || (selected_RightLowerButton_1))
        {
         int i,j;
         for(i=0;i<12;i++)
           {
            for(j=0;j<11;j++)
              {
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl-2*sz,y_pl,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl-2*sz-35,y_pl+15,window,dt_2,price_2);
                  RectangleCreate(0,name,0,dt_2,price_1,dt_1,price_2,StringToColor(plt_names_clr[i][j]),STYLE_SOLID,0,true,false,true,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==true) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl-2*sz,y_pl+45,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl-2*sz-35,y_pl+45,window,dt_2,price_2);
                  TrendCreate(0,name,0,dt_2,price_1,dt_1,price_2,StringToColor(plt_names_clr[i][j]),line_st,line_wd,InpBackRect,true,false,false,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==true) && (IsButtonPressedAlt()==false))
                 {
                  string name="name_"+IntegerToString(MathRand()+100,0,' ');
                  ChartXYToTimePrice(0,x_pl-2*sz,y_pl+20,window,dt_1,price_1);
                  ChartXYToTimePrice(0,x_pl-2*sz-35,y_pl+35,window,dt_2,price_2);
                  RectangleCreate(0,name,0,dt_2,price_1,dt_1,price_2,StringToColor(plt_names_clr[i][j]),STYLE_SOLID,1,false,false,true,InpHidden_OBJ,0);
                 }
               if((sparam=="PLT_name_"+plt_names[i][j]) && (IsButtonPressedCtrl()==false) && (IsButtonPressedShift()==false) && (IsButtonPressedAlt()==true))
                 {
                  int      m,objects_total_number;
                  string   object_name;
                  //----
                  objects_total_number=ObjectsTotal(-1);
                  if(objects_total_number>=1)
                    {
                     for(m=objects_total_number; m>=0; m--)
                       {
                        object_name=ObjectName(m);
                        if(ObjectGetInteger(0,object_name,OBJPROP_SELECTED)==true)
                          {
                           ObjectSetInteger(0,object_name,OBJPROP_COLOR,StringToColor(plt_names_clr[i][j]));
                           ObjectSetInteger(0,object_name,OBJPROP_LEVELCOLOR,StringToColor(plt_names_clr[i][j]));
                          }
                       }
                    }
                 }
              }
           }
        }
     }

//----
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreatePalette()
  {
   int i,j;
   for(i=0;i<12;i++)
      for(j=0;j<11;j++)
        {
           {
            if(!RectLabelCreate(0,"PLT_name_"+plt_names[i][j],0,x_pl+sz*j,y_pl+sz*i,sz,sz,StringToColor(plt_names_clr[i][j]),
               BORDER_FLAT,0,rect_icon_cl,rect_icon_st,rect_icon_wd,InpBackRect,InpSelection,InpHidden,0)){return;}
            ObjectSetString(0,"PLT_name_"+plt_names[i][j],OBJPROP_TOOLTIP,plt_names[i][j]);
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ObDeleteObjectsByPrefix(string Prefix)
  {
   int L = StringLen(Prefix);
   int i = 0;
   while(i<ObjectsTotal())
     {
      string ObjName=ObjectName(i);
      if(StringSubstr(ObjName,0,L)!=Prefix)
        {
         i++;
         continue;
        }
      ObjectDelete(ObjName);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               xx=0,                      // X coordinate
                  const int               yy=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  cornerr=CORNER_LEFT_UPPER,// chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   if(ObjectFind(chart_ID,name)<0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",GetLastError());
         return(false);
        }
      //--- set button coordinates
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
      //--- set button size
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      //--- set the chart's corner, relative to which point coordinates are defined
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,cornerr);
      //--- set the text
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      //--- set text font
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      //--- set font size
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      //--- set text color
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- set background color
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      //--- set border color
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- set button state
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      //--- enable (true) or disable (false) the mode of moving the button by mouse
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      //--- successful execution
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Создает прямоугольную метку                                      |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // ID графика
                     const string           name="RectLabel",         // имя метки
                     const int              sub_window=0,             // номер подокна
                     const int              x=0,                      // координата по оси X
                     const int              y=0,                      // координата по оси Y
                     const int              width=50,                 // ширина
                     const int              height=18,                // высота
                     const color            back_clr=C'236,233,216',  // цвет фона
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // угол графика для привязки
                     const color            clr=clrRed,               // цвет плоской границы (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы
                     const int              line_width=1,             // толщина плоской границы
                     const bool             back=false,               // на заднем плане
                     const bool             selection=false,          // выделить для перемещений
                     const bool             hidden=true,              // скрыт в списке объектов
                     const long             z_order=0)                // приоритет на нажатие мышью
  {
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим прямоугольную метку
   if(ObjectFind(name)==-1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);              // установим координаты метки
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);              // установим размеры метки
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);         // установим цвет фона
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);       // установим тип границы
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);            // установим угол графика, относительно которого будут определяться координаты точки
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);                // установим цвет плоской рамки (в режиме Flat)
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);              // установим стиль линии плоской рамки
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);         // установим толщину плоской границы
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);                // отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);     // включим (true) или отключим (false) режим перемещения метки мышью
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);            // скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);           // установим приоритет на получение события нажатия мыши на графике
   return(true);
  }
//+------------------------------------------------------------------+
//| Cоздает прямоугольник по заданным координатам                    |
//+------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID=0,        // ID графика
                     const string          name="Rectangle",  // имя прямоугольника
                     const int             sub_window=0,      // номер подокна 
                     datetime              time1=0,           // время первой точки
                     double                price1=0,          // цена первой точки
                     datetime              time2=0,           // время второй точки
                     double                price2=0,          // цена второй точки
                     const color           clr=clrRed,        // цвет прямоугольника
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линий прямоугольника
                     const int             width=1,           // толщина линий прямоугольника
                     const bool            fill=false,        // заливка прямоугольника цветом
                     const bool            back=false,        // на заднем плане
                     const bool            selection=true,    // выделить для перемещений
                     const bool            hidden=true,       // скрыт в списке объектов
                     const long            z_order=0)         // приоритет на нажатие мышью
  {
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим прямоугольник по заданным координатам
   if(ObjectFind(name)==-1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);             //--- установим цвет прямоугольника
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);           //--- установим стиль линий прямоугольника
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);           //--- установим толщину линий прямоугольника
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);             //--- включим (true) или отключим (false) режим заливки прямоугольника
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);             //--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);  //--- включим (true) или отключим (false) режим выделения прямоугольника для перемещений
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);    //--- при создании графического объекта функцией ObjectCreate, по умолчанию объект
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);         //--- скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);        //--- установим приоритет на получение события нажатия мыши на графике
   return(true);
  }
//+------------------------------------------------------------------+
//| Создает линию тренда по заданным координатам                     |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,        // ID графика
                 const string          name="TrendLine",  // имя линии
                 const int             sub_window=0,      // номер подокна
                 datetime              time1=0,           // время первой точки
                 double                price1=0,          // цена первой точки
                 datetime              time2=0,           // время второй точки
                 double                price2=0,          // цена второй точки
                 const color           clr=clrRed,        // цвет линии
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии
                 const int             width=1,           // толщина линии
                 const bool            back=false,        // на заднем плане
                 const bool            selection=true,    // выделить для перемещений
                 const bool            ray_left=false,    // продолжение линии влево
                 const bool            ray_right=false,   // продолжение линии вправо
                 const bool            hidden=true,       // скрыт в списке объектов
                 const long            z_order=0)         // приоритет на нажатие мышью
  {
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим трендовую линию по заданным координатам
   if(ObjectFind(name)==-1)
      ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);             //--- установим цвет линии
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);           //--- установим стиль отображения линии
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);           //--- установим толщину линии
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);             //--- отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);  //--- включим (true) или отключим (false) режим перемещения линии мышью
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);    //--- при создании графического объекта функцией ObjectCreate, по умолчанию объект
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left);     //--- включим (true) или отключим (false) режим продолжения отображения линии влево
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);   //--- включим (true) или отключим (false) режим продолжения отображения линии вправо
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);         //--- скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);        //--- установим приоритет на получение события нажатия мыши на графике
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
                 const string            font="Arial",             // font
                 const int               font_size=10,             // font size
                 const color             clr=clrRed,               // color
                 const double            angle=0.0,                // text slope
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back=false,               // in the background
                 const bool              selection=false,          // highlight to move
                 const bool              hidden=true,              // hidden in the object list
                 const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsButtonPressedCtrl()
  {return((TerminalInfoInteger((ENUM_TERMINAL_INFO_INTEGER)addbtn_1)&0x80)!=0);}
//+------------------------------------------------------------------+
bool IsButtonPressedShift()
  {return((TerminalInfoInteger((ENUM_TERMINAL_INFO_INTEGER)addbtn_2)&0x80)!=0);}
//+------------------------------------------------------------------+ 
bool IsButtonPressedAlt()
  {return((TerminalInfoInteger((ENUM_TERMINAL_INFO_INTEGER)addbtn_3)&0x80)!=0);}
//+------------------------------------------------------------------+ 
