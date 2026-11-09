package com.example.mobile_zpi

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Opens the app on the SOS screen, handled by HomeWidgetLaunchListener in Dart. */
class SosWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val views =
        RemoteViews(context.packageName, R.layout.widget_sos).apply {
          setOnClickPendingIntent(
              R.id.widget_sos,
              HomeWidgetLaunchIntent.getActivity(
                  context,
                  MainActivity::class.java,
                  Uri.parse("mobilezpi://sos"),
              ),
          )
        }
    appWidgetManager.updateAppWidget(appWidgetIds, views)
  }
}
