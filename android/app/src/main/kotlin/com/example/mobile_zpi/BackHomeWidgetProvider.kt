package com.example.mobile_zpi

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Opens the app on the walk home (`backHomeWidgetHost` in Dart). */
class BackHomeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val hasHome = widgetData.getBoolean("has_home", false)
    val views =
        RemoteViews(context.packageName, R.layout.widget_back_home).apply {
          setViewVisibility(
              R.id.widget_back_home_missing,
              if (hasHome) View.GONE else View.VISIBLE,
          )
          setOnClickPendingIntent(
              R.id.widget_back_home,
              HomeWidgetLaunchIntent.getActivity(
                  context,
                  MainActivity::class.java,
                  Uri.parse("zpi://back-home?homeWidget"),
              ),
          )
        }
    appWidgetManager.updateAppWidget(appWidgetIds, views)
  }
}
