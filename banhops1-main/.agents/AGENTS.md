# Agent Configuration / تهيئة العميل البرمجي

This file configures the behavior of the agent in this repository.
يحدد هذا الملف سلوك العميل البرمجي في هذا المستودع.

## Task Completion Notification / إشعار عند انتهاء المهمة

### English:
Whenever you finish executing any task or goal in this repository, you **MUST** run the following PowerShell command to play a notification sound (beep) and show a Windows popup to notify the user.

Run this command as the very last step of your task:
```powershell
powershell -Command "[Console]::Beep(1000, 300); (New-Object -ComObject WScript.Shell).Popup('The task has been successfully completed by the Agent!', 0, 'Agent Notification', 64)"
```

---

### باللغة العربية:
فور انتهائك من تنفيذ أي مهمة أو هدف في هذا المستودع، **يجب عليك** تشغيل أمر PowerShell التالي لإصدار صوت تنبيه (Beep) وإظهار نافذة منبثقة (Popup) في ويندوز لإشعار المستخدم.

قم بتشغيل هذا الأمر كخطوة أخيرة فور انتهائك من المهمة:
```powershell
powershell -Command "[Console]::Beep(1000, 300); (New-Object -ComObject WScript.Shell).Popup('The task has been successfully completed by the Agent!', 0, 'Agent Notification', 64)"
```
