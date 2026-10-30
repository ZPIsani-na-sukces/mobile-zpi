package com.example.mobile_zpi

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/** Opens walking navigation home in Google Maps without opening the app. */
class BackHomeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val url = widgetData.getString("back_home_url", null)
    val views =
        RemoteViews(context.packageName, R.layout.widget_back_home).apply {
          setViewVisibility(
              R.id.widget_back_home_missing,
              if (url == null) View.VISIBLE else View.GONE,
          )
          if (url != null) setOnClickPendingIntent(R.id.widget_back_home, mapsIntent(context, url))
        }
    appWidgetManager.updateAppWidget(appWidgetIds, views)
  }

  private fun mapsIntent(context: Context, url: String): PendingIntent {
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    return PendingIntent.getActivity(
        context,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
  }
}
