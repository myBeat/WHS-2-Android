package jp.co.uniontool.whs2;

import java.util.ArrayList;
import java.util.regex.Pattern;

import jp.co.uniontool.le.WhsCommands;
import jp.co.uniontool.le.WhsHelper;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.IBinder;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class DeviceSettingActivity extends ListActivity {
	private Intent mGattServiceIntent;
	private BluetoothLeService mBluetoothLeService;
	private ItemListAdapter mItemListAdapter;
	
	private boolean isReceiver = false;
	
	private static final int MODE_BEHAVIOR_INDEX = 0;
	private static final int MODE_ACCELERATION_INDEX = 1;
	private static final int BEHAVIOR_PQRST_INDEX = 0;
	private static final int BEHAVIOR_RRI_INDEX = 1;
	private static final int ACCELERATION_PEAK_INDEX = 1;
	private static final int ACCELERATION_AVERAGE_INDEX = 0;

	private final BroadcastReceiver mGattUpdateReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			final String action = intent.getAction();
			if (BluetoothLeService.ACTION_DATA_AVAILABLE_SETTING.equals(action)) {

				String command = intent.getStringExtra(WhsHelper.INTENT_COMMAND);
				String commandString = intent.getStringExtra(WhsHelper.INTENT_VALUE);

				if (command != null && command.equals("C2")) {
					Pattern p = Pattern.compile("^[0-9]*$");
					if (p.matcher(commandString.substring(4, 5)).find()) {
						String resultBehavior = commandString.substring(4, 5);
						setUpdateListValue(MODE_BEHAVIOR_INDEX, resultBehavior);
					}
					if (p.matcher(commandString.substring(5, 6)).find()) {
						String resultAcceleration = commandString.substring(5, 6);
						setUpdateListValue(MODE_ACCELERATION_INDEX, resultAcceleration);
					}
					mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandBehaviorAllRead);
				} else if (command != null && command.equals("C4")) {
					Pattern p = Pattern.compile("^[0-9]*$");
					if (p.matcher(commandString.substring(4, 5)).find()) {
						setUpdateListValue(MODE_BEHAVIOR_INDEX, commandString.substring(4, 5));
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandBehaviorRead);
					} else if (commandString.substring(4, 6).equals(WhsHelper.SETTING_RESULT_OK)) {
						mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandBehaviorRead);
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandBehaviorWritePqrst);
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandBehaviorWriteRri);
						mBluetoothLeService.writeCommands();
					}
				} else if (command != null && command.equals("C5")) {
					Pattern p = Pattern.compile("^[0-9]*$");
					if (p.matcher(commandString.substring(4, 5)).find()) {
						setUpdateListValue(MODE_ACCELERATION_INDEX, commandString.substring(4, 5));
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandAccelerationRead);
					} else if (commandString.substring(4, 6).equals(WhsHelper.SETTING_RESULT_OK)) {
						mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandAccelerationRead);
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandAccelerationWritePeak);
						mBluetoothLeService.mLeCommandContainer.delete(WhsCommands.CommandAccelerationWriteAverage);
						mBluetoothLeService.writeCommands();
					}
				}
			}
		}
	};
   
	private void setUpdateListValue(int mode, String result) {
		SettingItem item = null;
		switch (mode) {
		case MODE_BEHAVIOR_INDEX:
			item = setUpdateListValueBehavior(result);
			break;
		case MODE_ACCELERATION_INDEX:
			item = setUpdateListValueAcceleration(result);
			break;
		default:
			return;
		}
		mItemListAdapter.setSettingItem(item);
		mItemListAdapter.notifyDataSetChanged();
	}

	private SettingItem setUpdateListValueBehavior(String result) {
		SettingItem item = mItemListAdapter.getSettingItemByItemId(MODE_BEHAVIOR_INDEX);
		item.setSettingValue(result);
		return item;
	}

	private SettingItem setUpdateListValueAcceleration(String result) {
		SettingItem item = mItemListAdapter.getSettingItemByItemId(MODE_ACCELERATION_INDEX);
		item.setSettingValue(result);
		return item;
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		getActionBar().setDisplayHomeAsUpEnabled(true);

		mItemListAdapter = new ItemListAdapter();
		mItemListAdapter.addDevice(new SettingItem(MODE_BEHAVIOR_INDEX, 
				getString(R.string.setting_behavior), -1, "", "動作モードを設定する"));
		mItemListAdapter.addDevice(new SettingItem(MODE_ACCELERATION_INDEX, 
				getString(R.string.setting_acceleration), -1, "", "加速度モードを設定する"));
		setListAdapter(mItemListAdapter);
	}

	@Override
	protected void onResume() {
		super.onResume();

		registerReceiver(mGattUpdateReceiver, makeGattUpdateIntentFilter());
		isReceiver = true;
		
		mGattServiceIntent = new Intent(this, BluetoothLeService.class);
		bindService(mGattServiceIntent, mServiceConnection, BIND_AUTO_CREATE);
	}

	@Override
	protected void onPause() {
		super.onPause();
		writeReadSettingsFinish();
	}

	@Override
	protected void onStop() {
		super.onStop();
		if (isReceiver)
			unregisterReceiver(mGattUpdateReceiver);
		isReceiver = false;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unbindService(mServiceConnection);
		mBluetoothLeService = null;
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
	}

	@Override
	protected void onListItemClick(ListView listView, View v, int position, long id) {
		super.onListItemClick(listView, v, position, id);

		SettingItem item = (SettingItem) listView.getItemAtPosition(position);
		SettingItem si = mItemListAdapter.getSettingItemByItemId(item.getItemId());
		showSettingSelectDialog(si);
	}
	
	@Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_UP) {
            switch (event.getKeyCode()) {
            case KeyEvent.KEYCODE_BACK:
            	writeReadSettingsFinish();
            	onBackPressed();
                return true;
            default:
            }
        }
        return super.dispatchKeyEvent(event);
    }

	private void showSettingSelectDialog(SettingItem si) {
		if (si.getItemId() == MODE_BEHAVIOR_INDEX)
			showAlertDialogBuilderBehavior(si);
		else if (si.getItemId() == MODE_ACCELERATION_INDEX)
			showAlertDialogBuilderAcceleration(si);
	}
    
	private void showAlertDialogBuilderBehavior(SettingItem si) {
		final String[] itemBehaviors = new String[] { 
				getString(R.string.setting_pqrst), 
				getString(R.string.setting_rri) };
		
		new AlertDialog.Builder(this).setTitle(getString(R.string.setting_behavior))
				.setSingleChoiceItems(itemBehaviors, si.getItemValue(), new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						mBluetoothLeService.mLeCommandContainer.clear();
						switch (which) {
						case BEHAVIOR_PQRST_INDEX:
							mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandBehaviorWritePqrst);
							break;
						case BEHAVIOR_RRI_INDEX:
							mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandBehaviorWriteRri);
							break;
						}
						mBluetoothLeService.writeCommands();
						dialog.cancel();
					}
				}).create().show();
	}

	private void showAlertDialogBuilderAcceleration(SettingItem si) {
		final String[] itemAccelerations = new String[] { 
				getString(R.string.setting_acceleration_average), 
				getString(R.string.setting_acceleration_peak) };
		new AlertDialog.Builder(this).setTitle(getString(R.string.setting_acceleration))
				.setSingleChoiceItems(itemAccelerations, si.getItemValue(), new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						mBluetoothLeService.mLeCommandContainer.clear();
						switch (which) {
						case ACCELERATION_PEAK_INDEX:
							mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandAccelerationWritePeak);
							break;
						case ACCELERATION_AVERAGE_INDEX:
							mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandAccelerationWriteAverage);
							break;
						}
						mBluetoothLeService.writeCommands();
						dialog.cancel();
					}
				}).create().show();
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case android.R.id.home:
			writeReadSettingsFinish();
			onBackPressed();
			return true;
		default:
			return super.onOptionsItemSelected(item);
		}
	}

	@Override
	public void onBackPressed() {
		finish();
	}

	public void writeReadSettings() {
		mBluetoothLeService.mLeCommandContainer.clear();
		mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandSettingModeStart);
		mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandBehaviorAllRead);
		mBluetoothLeService.writeCommands();
	}

	public void writeReadSettingsFinish() {
		mBluetoothLeService.mLeCommandContainer.clear();
		mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandSettingModeEnd);
		mBluetoothLeService.mLeCommandContainer.add(WhsCommands.CommandMeasureModeStart);
		mBluetoothLeService.writeCommands();
	}

	static class ViewHolder {
		TextView itemRemarks;
		TextView itemName;
		TextView itemValue;
		TextView itemValueText;
	}

	protected final ServiceConnection mServiceConnection = new ServiceConnection() {
		@Override
		public void onServiceConnected(ComponentName componentName, IBinder service) {
			mBluetoothLeService = ((BluetoothLeService.LocalBinder) service).getService();
			if (!mBluetoothLeService.initialize()) finish();
			mBluetoothLeService.displayGattServices(true);
			writeReadSettings();
		}

		@Override
		public void onServiceDisconnected(ComponentName componentName) {
			mBluetoothLeService = null;
		}
	};
	
    private static IntentFilter makeGattUpdateIntentFilter() {
        final IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(BluetoothLeService.ACTION_DATA_AVAILABLE_SETTING);
        return intentFilter;
    }

	public class SettingItem {
		private int itemId;
		private String itemRemarks;
		private String itemName;
		private int itemValue;
		private String itemValueText;

		public SettingItem(int itemId, String itemName, int itemValue, String itemValueText, String itemRemarks) {
			this.itemId = itemId;
			this.itemRemarks = itemRemarks;
			this.itemValue = itemValue;
			this.itemName = itemName;
			this.itemValueText = itemValueText;
		}
		
		public void setSettingValue(String result) {
			if (this.itemId == MODE_BEHAVIOR_INDEX) {
				if (result.equals(WhsHelper.SETTING_VALUE_BEHAVIOR_PQRST)) {
					this.itemValue = 0;
				} else if (result.equals(WhsHelper.SETTING_VALUE_BEHAVIOR_RRI)) {
					this.itemValue = 1;
				}
				this.itemValueText = getBehaviorSettingName(Integer.valueOf(result));
			}
			
			if (this.itemId == MODE_ACCELERATION_INDEX) {
				if (result.equals(WhsHelper.SETTING_VALUE_ACCELERATION_AVERAGE)) {
					this.itemValue = 0;
				} else if (result.equals(WhsHelper.SETTING_VALUE_ACCELERATION_PEAK)) {
					this.itemValue = 1;
				}
				this.itemValueText = getAccelerationSettingName(Integer.valueOf(result));
			}			
		}

		public String getBehaviorSettingName(int type) {
			switch (type) {
			case 1:
				return getString(R.string.setting_pqrst);
			case 2:	
				return getString(R.string.setting_rri);
			}
			return "";
		}
		
		public String getAccelerationSettingName(int type) {
			switch (type) {
			case 0:
				return getString(R.string.setting_acceleration_average);
			case 1:	
				return getString(R.string.setting_acceleration_peak);
			}
			return "";
		}
		
		public int getItemId() {
			return this.itemId;
		}

		public String getItemName() {
			return this.itemName;
		}

		public int getItemValue() {
			return this.itemValue;
		}

		public String getItemValueText() {
			return this.itemValueText;
		}

		public void setItemValue(int value) {
			this.itemValue = value;
		}

		public void setItemValueText(String value) {
			this.itemValueText = value;
		}

		public String getItemRemarks() {
			return this.itemRemarks;
		}
	}

	private class ItemListAdapter extends BaseAdapter {
		private ArrayList<SettingItem> mItems;
		private LayoutInflater mInflator;

		public ItemListAdapter() {
			super();
			mItems = new ArrayList<SettingItem>();
			mInflator = DeviceSettingActivity.this.getLayoutInflater();
		}

		public void addDevice(SettingItem device) {
			if (!mItems.contains(device)) {
				mItems.add(device);
			}
		}

		public SettingItem getSettingItemByItemId(int itemId) {
			for (SettingItem si : mItems) {
				if (si.getItemId() == itemId)
					return si;
			}
			return null;
		}

		public void setSettingItem(SettingItem sip) {
			for (SettingItem item : mItems) {
				if (item.getItemId() == sip.getItemId()) {
					item = sip;
					return;
				}
			}
			mItems.add(sip);
		}

		@Override
		public int getCount() {
			return mItems.size();
		}

		@Override
		public Object getItem(int i) {
			return mItems.get(i);
		}

		@Override
		public long getItemId(int i) {
			return i;
		}

		@Override
		public View getView(int i, View view, ViewGroup viewGroup) {
			ViewHolder viewHolder;
			if (view == null) {
				view = mInflator.inflate(R.layout.list_item_setting, null);
				viewHolder = new ViewHolder();
				viewHolder.itemName = (TextView) view.findViewById(R.id.setting_item_name);
				viewHolder.itemRemarks = (TextView) view.findViewById(R.id.setting_item_remarks);
				viewHolder.itemValue = (TextView) view.findViewById(R.id.setting_item_value);
				viewHolder.itemValueText = (TextView) view.findViewById(R.id.setting_item_value_text);
				view.setTag(viewHolder);
			} else {
				viewHolder = (ViewHolder) view.getTag();
			}

			SettingItem item = mItems.get(i);
			final String itemName = item.getItemName();
			if (itemName != null && itemName.length() > 0) {
				viewHolder.itemName.setText(itemName);
			} else {
				viewHolder.itemName.setText("");
			}

			final int itemValue = item.getItemValue();
			if (itemValue >= 0) {
				viewHolder.itemValue.setText(Integer.toString(itemValue));
			} else {
				viewHolder.itemValue.setText("");
			}

			final String itemValueText = item.getItemValueText();
			if (itemValueText != null && itemValueText.length() > 0) {
				viewHolder.itemValueText.setText(itemValueText);
			} else {
				viewHolder.itemValueText.setText("");
			}

			viewHolder.itemRemarks.setText(item.getItemRemarks());
			return view;
		}
	}
}
