package com.example.mobile_zpi

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Opens the app on walking navigation home, handled by HomeWidgetLaunchListener in Dart. */
class BackHomeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val hasAddress = widgetData.getBoolean("back_home_has_address", false)
    val views =
        RemoteViews(context.packageName, R.layout.widget_back_home).apply {
          setViewVisibility(
              R.id.widget_back_home_missing,
              if (hasAddress) View.GONE else View.VISIBLE,
          )
          setOnClickPendingIntent(
              R.id.widget_back_home,
              HomeWidgetLaunchIntent.getActivity(
                  context,
                  MainActivity::class.java,
                  Uri.parse("mobilezpi://back-home"),
              ),
          )
        }
    appWidgetManager.updateAppWidget(appWidgetIds, views)
  }
}
