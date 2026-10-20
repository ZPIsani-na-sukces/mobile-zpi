package com.example.mobile_zpi

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Sends SOS in the background (`sosWidgetTask` in Dart) without opening the app. */
class SosWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val status = widgetData.getString("sos_status", null)
    val views =
        RemoteViews(context.packageName, R.layout.widget_sos).apply {
          setTextViewText(
              R.id.widget_sos_status,
              status ?: context.getString(R.string.widget_sos_hint),
          )
          setOnClickPendingIntent(
              R.id.widget_sos,
              HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("zpi://sos")),
          )
        }
    appWidgetManager.updateAppWidget(appWidgetIds, views)
  }
}
