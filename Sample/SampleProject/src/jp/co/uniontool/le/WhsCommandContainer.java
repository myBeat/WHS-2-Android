package jp.co.uniontool.le;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * WHS-2への送信コマンドを格納するためのクラス
 */
public class WhsCommandContainer {
	private ArrayList<Integer> mCommands = new ArrayList<Integer>();

	public int count() {
		return mCommands.size();
	}

	public ArrayList<Integer> getmCommands() {
		return mCommands;
	}

	public void add(int command) {
		if (isExistsCommand(command)) return;
		mCommands.add(command);
	}

	public void delete(int deleteCommand) {
		if (mCommands.size() == 0) return;

		for (Iterator<Integer> command = mCommands.iterator(); command.hasNext();) {
			if (command.next() == deleteCommand) {
				command.remove();
			}
		}
	}

	public void clear() {
		mCommands = new ArrayList<Integer>();
	}

	private boolean isExistsCommand(int checkCommand) {
		for (int command : mCommands) {
			if (command == checkCommand) return true;
		}
		return false;
	}
}
